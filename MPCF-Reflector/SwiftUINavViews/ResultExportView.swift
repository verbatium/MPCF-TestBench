//
//  ResultExportView.swift
//  MPCF-Reflector
//
//  Created by Joseph Heck on 5/16/20.
//  Copyright © 2020 JFH Consulting. All rights reserved.
//

import SwiftUI

#if os(iOS)
    struct ResultExportController: UIViewControllerRepresentable {
        let fileToExport: URL

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        func updateUIViewController(
            _ uiViewController: UIDocumentPickerViewController,
            context: UIViewControllerRepresentableContext<ResultExportController>
        ) {
            // Update the controller
        }

        func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
            print("Making the picker")
            let controller = UIDocumentPickerViewController.init(
                url: fileToExport,
                in: .exportToService
            )
            controller.delegate = context.coordinator
            print("Setup the delegate \(context.coordinator)")

            return controller
        }

        class Coordinator: NSObject, UIDocumentPickerDelegate {
            var parent: ResultExportController

            init(_ pickerController: ResultExportController) {
                self.parent = pickerController
                print("Setup a parent")
                print("URL: \(String(describing: self.parent.fileToExport))")
            }

            func documentPicker(didPickDocumentsAt: [URL]) {
                print("Selected a document: \(didPickDocumentsAt[0])")
            }

            func documentPickerWasCancelled() {
                print("Document picker was thrown away :(")
            }

            deinit {
                print("Coordinator going away")
            }
        }
    }
#elseif os(tvOS)
    struct ResultExportController: UIViewControllerRepresentable {
        let fileToExport: URL

        func updateUIViewController(
            _ uiViewController: UIViewController,
            context: UIViewControllerRepresentableContext<ResultExportController>
        ) {
            // Update the controller
        }

        func makeUIViewController(context: Context) -> UIViewController {
            print("Making the picker")
            let controller = UIViewController.init()
            return controller
        }
    }
#elseif os(macOS)
    struct ResultExportController: NSViewControllerRepresentable {
        let fileToExport: URL

        func updateNSViewController(
            _ uiViewController: NSViewController,
            context: NSViewControllerRepresentableContext<ResultExportController>
        ) {
            // Update the controller
        }

        func makeNSViewController(context: Context) -> NSViewController {
            print("Making the picker")
            let controller = NSViewController.init()

            return controller
        }
    }
#endif

struct ResultExportView: View {
    let fileToExport: URL

    #if os(iOS)
        let navStyle = StackNavigationViewStyle()
    #else
        let navStyle = DefaultNavigationViewStyle()
    #endif

    var body: some View {
        NavigationView {
            ResultExportController(fileToExport: fileToExport)
        }
        .navigationViewStyle(
            navStyle
        )
    }

}

#if DEBUG
    func dummyURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = paths[0].appendingPathComponent("output.mpcftestjson")
        do {
            try Data().write(to: filename, options: .atomicWrite)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print(error)
        }
        print(filename)
        return filename
    }

    struct ResultExportView_Previews: PreviewProvider {
        static var previews: some View {
            func filePicked(_ url: URL) {
                print("Filename: \(url)")
            }
            return
                ResultExportView(fileToExport: dummyURL())
                .aspectRatio(3 / 2, contentMode: .fit)
        }
    }
#endif
