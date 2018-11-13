/* Continue on
 *       Computing Round time trip (RTT)(Idea -- warning reception time can be taken constant value --> send two packets
 *                                               estimate their delay and add with sending delay)
 *		 Go to cellular Network as soon as possible
 */


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

/*
 * Delay and PDR Highly depends on
 * 		Distance
 * 		Number of nodes
 * 		Speed
 * 		Propagation Models
 * 		mobility model used
 * 		Simulation time
 * 		CAM Frequency
 * 		Client Start time (all start once or one after the other)
 * 		etc
 */




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

	for(double distance = 10;distance<130;distance=distance+50){
		std::cout<<"At Distance = "<<distance<<std::endl;
		std::cout<<"==============="<<std::endl;
		for (uint32_t nWifi = 4;nWifi<=54;nWifi=nWifi+10){
			bool tracing = false;
			uint32_t simulationTime = 20;

			CommandLine cmd;
			cmd.AddValue ("nWifi", "Number of wifi STA devices", nWifi);
			cmd.AddValue ("tracing", "Enable pcap tracing", tracing);

			cmd.Parse (argc,argv);

			std::string phyMode ("OfdmRate24Mbps"); //Data rate (Speed) maximum is 54

			NodeContainer ap;
			ap.Create (1);
			NodeContainer srv;
			srv.Create(1);
			NodeContainer sta;
			sta.Create (nWifi);

			WifiHelper wifi;
			wifi.SetStandard (WIFI_PHY_STANDARD_80211a);

		//==========================Configure Physical Layer===============================
			YansWifiPhyHelper wifiPhy =  YansWifiPhyHelper::Default ();
			wifiPhy.SetPcapDataLinkType (YansWifiPhyHelper::DLT_IEEE802_11_RADIO);
			wifiPhy.Set("TxPowerStart", DoubleValue(25));//25 dBm
			wifiPhy.Set("TxPowerEnd", DoubleValue(25));
			wifiPhy.Set("Frequency", UintegerValue(5000)); //5GH  as MHZ is the unit to write
			wifiPhy.Set("ChannelWidth", UintegerValue(20));// 20MHz ==> Band Width


			YansWifiChannelHelper wifiChannel;
			wifiChannel.SetPropagationDelay ("ns3::ConstantSpeedPropagationDelayModel");
			wifiChannel.AddPropagationLoss("ns3::NakagamiPropagationLossModel");
			wifiChannel.AddPropagationLoss ("ns3::LogDistancePropagationLossModel");
											/*,"Exponent", DoubleValue (3.0),
											"ReferenceLoss", DoubleValue (40.0459));*/
			//wifiChannel.AddPropagationLoss("ns3::ThreeLogDistancePropagationLossModel");

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

			  Ptr<ListPositionAllocator> positionAlloc = CreateObject<ListPositionAllocator> ();
			  positionAlloc->Add(Vector(0, 0, 5)); //10 is height of eNB
			  positionAlloc->Add(Vector(1, 0, 0));
			  MobilityHelper mobility;
			  mobility.SetMobilityModel("ns3::ConstantPositionMobilityModel");
			  mobility.SetPositionAllocator(positionAlloc);
			  mobility.Install(ap);
			  mobility.Install(srv);

			  Ptr<ListPositionAllocator> positionAllocSta = CreateObject<ListPositionAllocator> ();
				  for(uint32_t u=0;u<sta.GetN();u++)
					  positionAllocSta->Add(Vector(0, 0, 0));


				  mobility.SetMobilityModel("ns3::ConstantVelocityMobilityModel");
				  mobility.SetPositionAllocator(positionAllocSta);
				  mobility.Install(sta);


				  Ptr<ConstantVelocityMobilityModel> cvmVeh;
				  Ptr<ConstantVelocityMobilityModel> cvmPed;
				  for(uint32_t u=0;u<sta.GetN();u++){
					  if(u<sta.GetN()/2){
						  cvmVeh= sta.Get(u)->GetObject<ConstantVelocityMobilityModel>();
						  cvmVeh->SetVelocity(Vector (1.4, 0, 0)); //move Vehicle to right
					  }else{
						  cvmPed = sta.Get(u)->GetObject<ConstantVelocityMobilityModel>();
						  cvmPed->SetVelocity(Vector (1.4, 0, 0));
					  }
				  }


			  //Import Mobility trace from SUMO and apply to station nodes
				  /*  Ns2MobilityHelper NsMobility = Ns2MobilityHelper ("scratch/80ns2mobility.tcl");
			  NsMobility.Install (sta.Begin(), sta.End()); */


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
			  ApplicationContainer serverApps = echoServer.Install(srv.Get(0));

			  serverApps.Start (Seconds (1.0));
			  serverApps.Stop (Seconds (simulationTime));

			  UdpEchoClientHelper echoClient (allDevices.GetAddress(1), 9); //
			  echoClient.SetAttribute ("MaxPackets", UintegerValue (500));
			  echoClient.SetAttribute ("Interval", TimeValue (Seconds (1.0)));
			  echoClient.SetAttribute ("PacketSize", UintegerValue (1024));

			 for(uint32_t i=0;i < nWifi;i++){
				  ApplicationContainer clientApps1 = echoClient.Install (sta.Get (i));
				  clientApps1.Start (Seconds (1.5+i*0.1));
				  clientApps1.Stop (Seconds (simulationTime));
			   }


		//=============================Simulate==============================================
		   Ipv4GlobalRoutingHelper::PopulateRoutingTables ();
		  // AnimationInterface anim ("animation.xml");
		   Simulator::Stop (Seconds (simulationTime));

		  //PrintLocations(sta, "Original Location of all Station nodes"); //Initial location
		  //PrintLocations(ap, "Location of AP node");
		 // PrintLocations(srv, "Location of Server node");


			//std::ostringstream oss;
			//oss << "/NodeList/" << sta.Get(1)-> GetId() << "/$ns3::MobilityModel/CourseChange";
			//Config::Connect(oss.str(), MakeCallback(&CourseChange));

		// ===================================Flow monitor to Collect data======================
			Ptr<FlowMonitor> flowMonitor;
			FlowMonitorHelper flowHelper;
			flowMonitor = flowHelper.InstallAll();

			Simulator::Run ();

			//flowMonitor->SerializeToXmlFile("flows/6p6vFlow.xml", true, true);

			flowMonitor->CheckForLostPackets ();

			ns3::Time vehDelay;//, pedDelay;
			float vehRLP =0;//, pedRLP=0;
			Ptr<Ipv4FlowClassifier> classifier = DynamicCast<Ipv4FlowClassifier> (flowHelper.GetClassifier ());
			std::map<FlowId, FlowMonitor::FlowStats> stats = flowMonitor->GetFlowStats ();
			//uint nf = 2*nWifi;
			//uint quad = nWifi/2;
			for (std::map<FlowId, FlowMonitor::FlowStats>::const_iterator iter = stats.begin (); iter != stats.end (); ++iter){
				 /* Ipv4FlowClassifier::FiveTuple t = classifier->FindFlow (iter->first);
				   NS_LOG_UNCOND("Flow ID: " << iter->first << " Src Addr " << t.sourceAddress << " Dst Addr " << t.destinationAddress);
					  std::cout << "\tAverage Delay :" << iter->second.delaySum / float(iter->second.rxPackets * 1000000)  << " ms \n";
					  NS_LOG_UNCOND("\tTx Packets = " << iter->second.txPackets);
					  NS_LOG_UNCOND("\tRx Packets = " << iter->second.rxPackets);
					  std::cout << "\tTotal number of lost packets :" << iter->second.txPackets - iter->second.rxPackets  << "\n";
					  std::cout << " \tRatio lost packets :" << float(100*((iter->second.txPackets - iter->second.rxPackets))/float(iter->second.txPackets))  << "\n";
					  NS_LOG_UNCOND("\tThroughput: " << iter->second.rxBytes * 8.0 / (iter->second.timeLastRxPacket.GetSeconds()-iter->second.timeFirstTxPacket.GetSeconds()) / 1024  << " Kbps");
				  */

				ns3::Time tempDelay=	 iter->second.delaySum / float(iter->second.rxPackets * 1000000);
				double tempRlp=float(100*((iter->second.txPackets - iter->second.rxPackets))/float(iter->second.txPackets));

				/*if(iter->first<=quad || ((iter->first > quad) and (iter->first <= nf-quad)) ){
					vehDelay = vehDelay+tempDelay;
					vehRLP=vehRLP+tempRlp;
					//cout<<"Vehicle Flow number= "<<iter->first<<endl;
				}else{
					pedDelay = pedDelay+tempDelay;
					pedRLP=pedRLP+tempRlp;
					//cout<<"Pedestrian Flow number= "<<iter->first<<endl;
				}*/
				vehDelay = vehDelay+tempDelay;
				vehRLP=vehRLP+tempRlp;

			}
		   std::cout<<"Number of nodes = "<<nWifi<<std::endl;

		   std::cout <<"\tDelay  = "<<vehDelay/nWifi<<std::endl;
		   //std::cout <<"\tDelay Pedestrian= "<<pedDelay/quad<<std::endl;
		 //  std::cout <<"\tPLR  = "<<vehRLP/nWifi<<std::endl;
		   //std::cout <<"\tPLR Pedestrian= "<<pedRLP/quad<<std::endl;

			Simulator::Destroy ();
		}

	}

	return 0;
}
