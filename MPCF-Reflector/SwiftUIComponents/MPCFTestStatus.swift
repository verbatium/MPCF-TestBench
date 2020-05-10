//
//  MPCFTestControl.swift
//  MPCF-Reflector
//
//  Created by Joseph Heck on 5/3/20.
//  Copyright © 2020 JFH Consulting. All rights reserved.
//

import MultipeerConnectivity
import PreviewBackground
import SwiftUI

struct MPCFTestStatus: View {

    private let df = DateFormatter()
    private func stringFromDate(_ date: Date) -> String {
        df.dateFormat = "y-MM-dd H:m:ss.SSSS"
        return df.string(from: date)
    }

    @ObservedObject var testRunnerModel: MPCFTestRunnerModel
    var body: some View {
        VStack(alignment: .leading) {

            Text("Target: ").font(.headline)
                + Text("\(testRunnerModel.targetPeer?.displayName ?? "???")")
            Divider()
            HStack {
                Text("Sent         ").font(.headline)
                ProgressBar(
                    value: Double(testRunnerModel.numberOfTransmissionsSent),
                    maxValue: testRunnerModel.numberOfTransmissionsToSend
                )
            }

            Divider()
            HStack {
                Text("Received").font(.headline)
                ProgressBar(
                    value: Double(testRunnerModel.numberOfTransmissionsRecvd),
                    maxValue:
                        testRunnerModel.numberOfTransmissionsToSend
                )
            }
            Divider()
            List(testRunnerModel.reportsReceived, id: \.self) {
                xmitreport in
                Text("\(xmitreport.bandwidth, specifier: "%.2f") bytes/sec ")
                    + Text("at \(self.stringFromDate(xmitreport.end))")
                    .font(.caption)
            }
            Divider()
            Text("Summary")
            HStack {
                Text("Average: \(testRunnerModel.summary.average, specifier: "%.2f")")
                Text("StdDev: \(testRunnerModel.summary.stddev, specifier: "%.2f")")
                Text("Max: \(testRunnerModel.summary.max, specifier: "%.2f")")
            }
        }

    }
}

#if DEBUG
    private func fakeTestRunner() -> MPCFTestRunnerModel {
        let myself = MCPeerID(displayName: "me")
        let me = MPCFTestRunnerModel(peer: myself, OTSimpleSpanCollector())
        me.targetPeer = MCPeerID(displayName: "livePeer")
        me.numberOfTransmissionsToSend = 100
        // record that we've sent 35
        me.numberOfTransmissionsSent = 35
        // record that we've received 20
        me.numberOfTransmissionsRecvd = 20
        for _ in 1...20 {
            me.reportsReceived.append(
                RoundTripXmitReport(
                    start: Date(),
                    end: Date() + TimeInterval(1),
                    dataSize: 4321
                )
            )
        }

        return me
    }

    struct MPCFTestStatus_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
                    PreviewBackground {
                        VStack(alignment: .leading) {
                            MPCFTestStatus(testRunnerModel: fakeTestRunner())
                        }
                    }
                    .environment(\.colorScheme, colorScheme)
                    .previewDisplayName("\(colorScheme)")
                }
            }
        }
    }
#endif
