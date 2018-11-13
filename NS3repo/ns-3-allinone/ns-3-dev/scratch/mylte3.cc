/* -*-  Mode: C++; c-file-style: "gnu"; indent-tabs-mode:nil; -*- */
/*
 * Copyright (c) 2011 Centre Tecnologic de Telecomunicacions de Catalunya (CTTC)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation;
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Author: Jaume Nin <jaume.nin@cttc.cat>
 */

#include "ns3/lte-helper.h"
#include "ns3/epc-helper.h"
#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/ipv4-global-routing-helper.h"
#include "ns3/internet-module.h"
#include "ns3/mobility-module.h"
#include "ns3/lte-module.h"
#include "ns3/applications-module.h"
#include "ns3/point-to-point-helper.h"
#include "ns3/config-store.h"
//#include "ns3/gtk-config-store.h"

#include "ns3/flow-monitor-helper.h"
#include "ns3/flow-monitor-module.h"

#include "ns3/netanim-module.h"

using namespace ns3;

/**
 * Sample simulation script for LTE+EPC. It instantiates several eNodeB,
 * attaches one UE per eNodeB starts a flow for each UE to  and from a remote host.
 * It also  starts yet another flow between each UE pair.
 */

NS_LOG_COMPONENT_DEFINE ("EpcFirstExample");

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
int
main (int argc, char *argv[])
{

for (double distance = 1000.0;distance<=10000;distance=distance+1000){
  uint16_t numberOfUENodes = 1;
  uint16_t numberOfENBNodes = 1;
  double simTime =100;
 // double distance = 6000.0;
  double interPacketInterval = 1;

  // ================================= Command line arguments =========================
  CommandLine cmd;
  cmd.AddValue("numberOfNodes", "Number of UE nodes", numberOfUENodes);
  cmd.AddValue("numberOfNodes", "Number of eNodeBs", numberOfENBNodes);
  cmd.AddValue("simTime", "Total duration of the simulation [s])", simTime);
  cmd.AddValue("distance", "Distance between eNBs and host server[m]", distance);
  cmd.AddValue("interPacketInterval", "Inter packet interval [s])", interPacketInterval);
  cmd.Parse(argc, argv);


  	  Ptr<LteHelper> lteHelper = CreateObject<LteHelper> ();
	  Ptr<PointToPointEpcHelper>  epcHelper = CreateObject<PointToPointEpcHelper> ();
	  lteHelper->SetEpcHelper (epcHelper);
	  ConfigStore inputConfig;
	  inputConfig.ConfigureDefaults();
	  lteHelper->SetAttribute("Scheduler", StringValue("ns3::PfFfMacScheduler"));
	  lteHelper->SetAttribute ("PathlossModel", StringValue ("ns3::NakagamiPropagationLossModel"));
	  //lteHelper->SetAttribute ("PathlossModel", StringValue ("ns3::ThreeLogDistancePropagationLossModel"));
	  lteHelper->SetAttribute ("PathlossModel", StringValue ("ns3::FriisPropagationLossModel"));

	  Config::SetDefault ("ns3::LteEnbRrc::SrsPeriodicity", UintegerValue (160));

	  cmd.Parse(argc, argv);// parse again so you can override default values from the command line

	  Ptr<Node> pgw = epcHelper->GetPgwNode ();

	   // Create a single RemoteHost
	  NodeContainer remoteHostContainer;
	  remoteHostContainer.Create (1);
	  Ptr<Node> remoteHost = remoteHostContainer.Get (0);
	  InternetStackHelper internet;
	  internet.Install (remoteHostContainer);

	  // Create the Internet
	  PointToPointHelper p2ph;
	  p2ph.SetDeviceAttribute ("DataRate", DataRateValue (DataRate ("100Gb/s")));
	  p2ph.SetDeviceAttribute ("Mtu", UintegerValue (1500)); //Maximum Transmission Unit
	  //p2ph.SetChannelAttribute ("Delay", TimeValue (Seconds (0.010))); 	//Add path loss and delay propagation models

	  NetDeviceContainer internetDevices = p2ph.Install (pgw, remoteHost);

	  Ipv4AddressHelper ipv4h;
	  ipv4h.SetBase ("1.0.0.0", "255.0.0.0");
	  Ipv4InterfaceContainer internetIpIfaces = ipv4h.Assign (internetDevices);
	  // interface 0 is localhost, 1 is the p2p device
	  Ipv4Address remoteHostAddr = internetIpIfaces.GetAddress (1);

	  //std::cout<<"Ip Address of PGW: "<<internetIpIfaces.GetAddress(0)<<std::endl;
	 // std::cout<<"Ip Address of Remote Host: "<<internetIpIfaces.GetAddress(1)<<std::endl;


	  Ipv4StaticRoutingHelper ipv4RoutingHelper;
	  Ptr<Ipv4StaticRouting> remoteHostStaticRouting = ipv4RoutingHelper.GetStaticRouting (remoteHost->GetObject<Ipv4> ());
	  remoteHostStaticRouting->AddNetworkRouteTo (Ipv4Address ("7.0.0.0"), Ipv4Mask ("255.0.0.0"), 1);
	  NodeContainer ueNodes;
	  NodeContainer enbNodes;
	  enbNodes.Create(numberOfENBNodes);
	  ueNodes.Create(numberOfUENodes);

	  //=================================== Setting Mobility ==========================
	  Ptr<ListPositionAllocator> positionAlloc = CreateObject<ListPositionAllocator> ();
	  positionAlloc->Add(Vector(0, 0, 10)); //10 is height of eNB
	  positionAlloc->Add(Vector(0, 0, 0));
	  MobilityHelper mobility;
	  mobility.SetMobilityModel("ns3::ConstantPositionMobilityModel");
	  mobility.SetPositionAllocator(positionAlloc);
	  mobility.Install(enbNodes);
	  mobility.Install(remoteHost);

	  Ptr<ListPositionAllocator> positionAllocUE = CreateObject<ListPositionAllocator> ();
	  for(uint32_t u=0;u<ueNodes.GetN();u++)
		  positionAllocUE->Add(Vector(distance-u*10, 0, 0));


	  mobility.SetMobilityModel("ns3::ConstantVelocityMobilityModel");
	  mobility.SetPositionAllocator(positionAllocUE);
	  mobility.Install(ueNodes);

	  Ptr<ConstantVelocityMobilityModel> cvmVeh;
	  Ptr<ConstantVelocityMobilityModel> cvmPed;
	  for(uint32_t u=0;u<ueNodes.GetN();u++){
		  cvmVeh= ueNodes.Get(u)->GetObject<ConstantVelocityMobilityModel>();
	  	  cvmVeh->SetVelocity(Vector (1.44, 0, 0)); //move Vehicle to right
	  }
	  //cvmPed = ueNodes.Get(1)->GetObject<ConstantVelocityMobilityModel>();
	  //cvmPed->SetVelocity(Vector (1.4, 0, 0)); //move Pedestrian to right 1.4.0m/s

	  //================================== Fading Traces ============================
	  lteHelper->SetFadingModel("ns3::TraceFadingLossModel");
	  lteHelper->SetFadingModelAttribute ("TraceFilename", StringValue ("src/lte/model/fading-traces/fading_trace_EPA_3kmph.fad"));
	  lteHelper->SetFadingModelAttribute ("TraceLength", TimeValue (Seconds (10.0)));
	  lteHelper->SetFadingModelAttribute ("SamplesNum", UintegerValue (10000));
	  lteHelper->SetFadingModelAttribute ("WindowSize", TimeValue (Seconds (0.5)));
	  lteHelper->SetFadingModelAttribute ("RbNum", UintegerValue (100));

	  // Install LTE Devices to the nodes
	  NetDeviceContainer enbLteDevs = lteHelper->InstallEnbDevice (enbNodes);
	  NetDeviceContainer ueLteDevs = lteHelper->InstallUeDevice (ueNodes);

	  // Install the IP stack on the UEs
	  internet.Install (ueNodes);
	  Ipv4InterfaceContainer ueIpIface;
	  ueIpIface = epcHelper->AssignUeIpv4Address (NetDeviceContainer (ueLteDevs));

	 // std::cout<<"Ip Address of UE Node 1: "<<ueIpIface.GetAddress(0)<<std::endl;
	 // std::cout<<"Ip Address of UE Node 2: "<<ueIpIface.GetAddress(1)<<std::endl;

	  for (uint32_t u = 0; u < ueNodes.GetN (); ++u){// Assign IP address to UEs, and install applications
		  Ptr<Node> ueNode = ueNodes.Get (u);
		  Ptr<Ipv4StaticRouting> ueStaticRouting = ipv4RoutingHelper.GetStaticRouting (ueNode->GetObject<Ipv4> ());
		  ueStaticRouting->SetDefaultRoute (epcHelper->GetUeDefaultGatewayAddress (), 1); // Set the default gateway for the UE
		}


	  // Attach UEs for eNodeB
	  for(uint32_t u=0;u<ueNodes.GetN();u++)
		  lteHelper->Attach (ueLteDevs.Get(u), enbLteDevs.Get(0)); //modify
	  //lteHelper->Attach (ueLteDevs.Get(1), enbLteDevs.Get(0));

	  // Install and start applications on UEs and remote host
	  uint16_t dlPort = 1234;
	  uint16_t ulPort = 2000;
	  uint16_t otherPort = 3000;
	  ApplicationContainer clientApps;
	  ApplicationContainer serverApps;

	  for (uint32_t u = 0; u < ueNodes.GetN (); ++u) {
		  ++ulPort;
		  ++otherPort;
		  PacketSinkHelper dlPacketSinkHelper ("ns3::UdpSocketFactory", InetSocketAddress (Ipv4Address::GetAny (), dlPort));
		  PacketSinkHelper ulPacketSinkHelper ("ns3::UdpSocketFactory", InetSocketAddress (Ipv4Address::GetAny (), ulPort));
		  PacketSinkHelper packetSinkHelper ("ns3::UdpSocketFactory", InetSocketAddress (Ipv4Address::GetAny (), otherPort));
		  serverApps.Add (dlPacketSinkHelper.Install (ueNodes.Get(u)));
		  serverApps.Add (ulPacketSinkHelper.Install (remoteHost));
		  serverApps.Add (packetSinkHelper.Install (ueNodes.Get(u)));

		  UdpClientHelper dlClient (ueIpIface.GetAddress (u), dlPort);
		  dlClient.SetAttribute ("Interval", TimeValue (Seconds(interPacketInterval)));
		  dlClient.SetAttribute ("PacketSize", UintegerValue (1000));
		  dlClient.SetAttribute ("MaxPackets", UintegerValue(1000));

		  UdpClientHelper ulClient (remoteHostAddr, ulPort);
		  ulClient.SetAttribute ("Interval", TimeValue (Seconds(interPacketInterval)));
		  ulClient.SetAttribute ("PacketSize", UintegerValue (1000));
		  ulClient.SetAttribute ("MaxPackets", UintegerValue(1000));

		  UdpClientHelper client (ueIpIface.GetAddress (u), otherPort);
		  client.SetAttribute ("Interval", TimeValue (Seconds(interPacketInterval)));
		  client.SetAttribute ("PacketSize", UintegerValue (1000));
		  client.SetAttribute ("MaxPackets", UintegerValue(1000));

		  clientApps.Add (dlClient.Install (remoteHost));
		  clientApps.Add (ulClient.Install (ueNodes.Get(u)));
		}

	  serverApps.Start (Seconds (1.0));
	  clientApps.Start (Seconds (1.5));
	 // lteHelper->EnableTraces ();
	  // Uncomment to enable PCAP tracing
	 // p2ph.EnablePcapAll("lena-epc-first");

	 // PrintLocations(ueNodes, "Original Location of UE nodes"); //Initial location
	 // PrintLocations(enbNodes, "Location of eNB node");
	 // PrintLocations(remoteHost, "Location of Remote Server");


	  //AnimationInterface anim ("animation.xml");
	  Simulator::Stop(Seconds(simTime));

	  Ptr<FlowMonitor> flowMonitor;
	  FlowMonitorHelper flowHelper;
	  flowMonitor = flowHelper.InstallAll();

	  Simulator::Run ();
	  //flowMonitor->SerializeToXmlFile("flow.xml", true, true);

	//============================== Output Result ============================================
	 	//ns3::Time delay;
		float rlp=0.0;
		Ptr<Ipv4FlowClassifier> classifier = DynamicCast<Ipv4FlowClassifier> (flowHelper.GetClassifier ());
			std::map<FlowId, FlowMonitor::FlowStats> stats = flowMonitor->GetFlowStats ();
			for (std::map<FlowId, FlowMonitor::FlowStats>::const_iterator iter = stats.begin (); iter != stats.end (); ++iter){
				  //Ipv4FlowClassifier::FiveTuple t = classifier->FindFlow (iter->first);
				  //NS_LOG_UNCOND("Flow ID: " << iter->first << " Src Addr " << t.sourceAddress << " Dst Addr " << t.destinationAddress);
				  //std::cout << "\tAverage Delay :" << iter->second.delaySum / float(iter->second.rxPackets*1000000)  << " ms \n";
				  //NS_LOG_UNCOND("\tTx Packets = " << iter->second.txPackets);
				  //NS_LOG_UNCOND("\tRx Packets = " << iter->second.rxPackets);
				  //std::cout << "\tTotal number of lost packets :" << iter->second.txPackets - iter->second.rxPackets  << "\n";
				  //std::cout << " \tRatio lost packets :" << float(100*((iter->second.txPackets - iter->second.rxPackets))/float(iter->second.txPackets))  << "\n";
				  // NS_LOG_UNCOND("\tThroughput: " << iter->second.rxBytes * 8.0 / (iter->second.timeLastRxPacket.GetSeconds()-iter->second.timeFirstTxPacket.GetSeconds()) / 1024  << " Kbps");
				if(iter->second.rxPackets!=0){
					//delay = delay+iter->second.delaySum / float(iter->second.rxPackets*1000000);
					rlp=rlp+float((100*(iter->second.txPackets - iter->second.rxPackets))/float(iter->second.txPackets));
				}
					/*  if(iter->first==1)
						  delay1 = delay;
					  else if(iter->first==2)
						 delay2 = delay;
					  else if(iter->first==3)
						 delay3 = delay;
					  else
						 delay4 = delay;*/

			  }//end of for loop
		   //vehDelay = delay1+delay3;
		 // pedDelay = delay2+delay4;
		  std::cout<<"At Distance (5kmph)  = "<<distance<<std::endl;
		  //std::cout <<"\tDelay = "<<delay/numberOfUENodes<<std::endl;
		  std::cout <<"\tPLR= "<<rlp/numberOfUENodes<<std::endl;

	//========================================================================================

	  Simulator::Destroy();
	}
  return 0;

}

