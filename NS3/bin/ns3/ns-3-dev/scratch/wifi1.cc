#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/applications-module.h"
#include "ns3/wifi-module.h"
#include "ns3/mobility-module.h"
#include "ns3/internet-module.h"

#include "ns3/ns2-mobility-helper.h"
#include "ns3/netanim-module.h"

#include "ns3/flow-monitor-helper.h"
#include "ns3/flow-monitor-module.h"

#include<iostream>

using namespace ns3;
using namespace std;


NS_LOG_COMPONENT_DEFINE ("WifiExample");

void
CourseChange (std::string context, Ptr<const MobilityModel> model)
{
	Vector position = model->GetPosition ();
	NS_LOG_UNCOND (context <<
			" x = " << position.x << ", y = " << position.y);
}

void
PrintLocations (NodeContainer nodes, std::string header)
{
    std::cout << header << std::endl;
    for(NodeContainer::Iterator iNode = nodes.Begin (); iNode != nodes.End (); ++iNode)
    {
        Ptr<Node> object = *iNode;
        Ptr<MobilityModel> position = object->GetObject<MobilityModel> ();
        NS_ASSERT (position != 0);
        Vector pos = position->GetPosition ();
        std::cout << "(" << pos.x << ", " << pos.y << ", " << pos.z << ")" << std::endl;
    }
    std::cout << std::endl;
}



int main(int argc,char *argv[]) {

	//LogComponentEnable ("UdpEchoClientApplication", LOG_LEVEL_INFO);
	//LogComponentEnable ("UdpEchoServerApplication", LOG_LEVEL_INFO);

	uint32_t nWifi = 12;
	bool tracing = false;
	uint32_t simulationTime = 300;

    CommandLine cmd;
	cmd.AddValue ("nWifi", "Number of wifi STA devices", nWifi);
	cmd.AddValue ("tracing", "Enable pcap tracing", tracing);

	cmd.Parse (argc,argv);

	std::string phyMode ("DsssRate1Mbps");

	NodeContainer ap;
	ap.Create (1);
	NodeContainer srv;
	srv.Create(1);
	NodeContainer sta;
	sta.Create (nWifi);

	WifiHelper wifi;
	wifi.SetStandard (WIFI_PHY_STANDARD_80211b);

//==========================Configure Physical Layer===============================
	YansWifiPhyHelper wifiPhy =  YansWifiPhyHelper::Default ();
	wifiPhy.SetPcapDataLinkType (YansWifiPhyHelper::DLT_IEEE802_11_RADIO);
	wifiPhy.Set("TxPowerStart", DoubleValue(25));//25 dBm
	wifiPhy.Set("TxPowerEnd", DoubleValue(25));
	wifiPhy.Set("Frequency", UintegerValue(2400)); //2.4MHZ
	wifiPhy.Set("ChannelWidth", UintegerValue(20));// 20MHz


	YansWifiChannelHelper wifiChannel;
	wifiChannel.SetPropagationDelay ("ns3::ConstantSpeedPropagationDelayModel");
	/*wifiChannel.AddPropagationLoss ("ns3::LogDistancePropagationLossModel",
	                                "Exponent", DoubleValue (3.0),
	                                "ReferenceLoss", DoubleValue (40.0459));*/
	wifiChannel.AddPropagationLoss("ns3::NakagamiPropagationLossModel");
	wifiPhy.SetChannel (wifiChannel.Create ());

//==============================Configure MAC Layer and Create Devices==========================
	// Add a non-QoS upper mac, and disable rate control
	WifiMacHelper wifiMac;
	wifi.SetRemoteStationManager ("ns3::ConstantRateWifiManager",
	                              "DataMode",StringValue (phyMode),
	                              "ControlMode",StringValue (phyMode));

	// Setup the rest of the upper mac
	Ssid ssid = Ssid ("wifi-default");
	// setup ap.
	wifiMac.SetType ("ns3::ApWifiMac",
	                 "Ssid", SsidValue (ssid));
	NetDeviceContainer apDevice = wifi.Install (wifiPhy, wifiMac, ap);
	NetDeviceContainer devices = apDevice;

	// setup sta.
	wifiMac.SetType ("ns3::StaWifiMac",
	                 "Ssid", SsidValue (ssid),
	                 "ActiveProbing", BooleanValue (false));
	NetDeviceContainer srvDevice = wifi.Install(wifiPhy, wifiMac, srv);
	devices.Add(srvDevice);
	NetDeviceContainer staDevice = wifi.Install (wifiPhy, wifiMac, sta);
	devices.Add (staDevice);

//=========================== Configure mobility====================================

	  MobilityHelper srvAPmobility;
	  srvAPmobility.SetPositionAllocator ("ns3::GridPositionAllocator",
	                                 "MinX", DoubleValue (100.0),
	                                 "MinY", DoubleValue (100.0),
	                                 "DeltaX", DoubleValue (0.0),
	                                 "DeltaY", DoubleValue (100.0),
	                                 "GridWidth", UintegerValue (100.0),
	                                 "LayoutType", StringValue ("RowFirst"));
	  //Server and AP do not move
	  srvAPmobility.SetMobilityModel ("ns3::ConstantPositionMobilityModel");
	  srvAPmobility.Install (ap);
	  srvAPmobility.Install (srv);

	  //Import Mobility trace from SUM and apply to station nodes
	  Ns2MobilityHelper mobility = Ns2MobilityHelper ("scratch/6p6vns2mobility.tcl");
	  mobility.Install (sta.Begin(), sta.End());



	  /*
		double srvToAPDist = sqrt(mobility.GetDistanceSquaredBetween(srv.Get(0), ap.Get(0)));
		for(uint32_t i=0;i<nWifi;i++){
			double apToStaDist = sqrt(mobility.GetDistanceSquaredBetween(ap.Get(0), sta.Get(i)));
			double totalDist = apToStaDist + srvToAPDist;
			cout<<" Total Distance b/n Server and Client of Node is "<<i+1<<totalDist<<endl;
		}*/

//============================Internet===========================================
	  InternetStackHelper stack;
	  stack.Install (sta);
	  stack.Install (srv);
	  stack.Install (ap);

	  Ipv4AddressHelper address;
	  address.SetBase ("10.1.1.0", "255.255.255.0");

	  Ipv4InterfaceContainer allDevices;
	  allDevices = address.Assign (devices);

//===========================Applications=======================================
	  UdpEchoServerHelper echoServer (9);
	  ApplicationContainer serverApps = echoServer.Install(srv.Get(0)); //the first station node is the server

	  serverApps.Start (Seconds (1.0));
	  serverApps.Stop (Seconds (simulationTime));

	  UdpEchoClientHelper echoClient (allDevices.GetAddress(1), 9); //
	  echoClient.SetAttribute ("MaxPackets", UintegerValue (500));
	  echoClient.SetAttribute ("Interval", TimeValue (Seconds (1.0)));
	  echoClient.SetAttribute ("PacketSize", UintegerValue (1024));

	  for(uint32_t i=0;i < nWifi;i++){
		 // cout<<"Station Node number = "<<i<<endl;
		  ApplicationContainer clientApps1 = echoClient.Install (sta.Get (i));
		  clientApps1.Start (Seconds (1.5));
		  clientApps1.Stop (Seconds (simulationTime));
	  }

//=============================Simulate==============================================
   Ipv4GlobalRoutingHelper::PopulateRoutingTables ();
  // AnimationInterface anim ("animation.xml");
   Simulator::Stop (Seconds (simulationTime));

     PrintLocations(sta, "Original Location of all Station nodes"); //Initial location
     PrintLocations(ap, "Location of AP node");
     PrintLocations(srv, "Location of Server node");

// ===================================Flow monitor to Collect data======================
   	Ptr<FlowMonitor> flowMonitor;
   	FlowMonitorHelper flowHelper;
   	flowMonitor = flowHelper.InstallAll();

   	Simulator::Run ();

   	flowMonitor->SerializeToXmlFile("flows/6p6vFlow.xml", true, true);

   	flowMonitor->CheckForLostPackets ();
   	Ptr<Ipv4FlowClassifier> classifier = DynamicCast<Ipv4FlowClassifier> (flowHelper.GetClassifier ());
   	std::map<FlowId, FlowMonitor::FlowStats> stats = flowMonitor->GetFlowStats ();
   	for (std::map<FlowId, FlowMonitor::FlowStats>::const_iterator iter = stats.begin (); iter != stats.end (); ++iter){
		  Ipv4FlowClassifier::FiveTuple t = classifier->FindFlow (iter->first);
		  if(t.sourceAddress!="10.1.1.2"){
			  NS_LOG_UNCOND("Flow ID: " << iter->first << " Src Addr " << t.sourceAddress << " Dst Addr " << t.destinationAddress);
			  std::cout << "\tAverage Delay :" << iter->second.delaySum / float(iter->second.rxPackets * 1000000*2)  << " ms \n";
			  NS_LOG_UNCOND("\tTx Packets = " << iter->second.txPackets);
			  NS_LOG_UNCOND("\tRx Packets = " << iter->second.rxPackets);
			  std::cout << "\tTotal number of lost packets :" << iter->second.txPackets - iter->second.rxPackets  << "\n";
			  std::cout << " \tRatio lost packets :" << float(100*((iter->second.txPackets - iter->second.rxPackets))/float(iter->second.txPackets))  << "\n";
			  NS_LOG_UNCOND("\tThroughput: " << iter->second.rxBytes * 8.0 / (iter->second.timeLastRxPacket.GetSeconds()-iter->second.timeFirstTxPacket.GetSeconds()) / 1024  << " Kbps");
		  }
   	  }

    Simulator::Destroy ();

	return 0;
}
