//
//  CreateInstallerView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/20/21.
//

import VeliaUI

struct CreateInstallerView: View {
    @Binding var p: PSPage
    @State var errorX = "EXTRACT"
    @Binding var password: String
    @Binding var showPass: Bool
    @State var hovered: String?
    @State var progressText = ""
    @Binding var volume: String
    @Binding var installInfo: InstallAssistant?
    @State var isBeta = ""
    
    var body: some View {
        VStack {
            Text("Creating USB Installer")
                .font(.system(size: 15)).bold()
            Text("Now the USB you selected is being used to create a macOS installer USB. The files copied on the disk create an environment similar to macOS Big Sur Recovery Mode. Once those files are placed on the USB, Patched Sur steps in and patches it allowing for your Mac to boot into it and giving it some useful tools for a patched Mac.")
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
            if password == "" || showPass {
                VIButton(id: "REQUEST-ROOT", h: $hovered) {
                    Text("Request Root Permissions")
                } onClick: {
                    withAnimation {
                        showPass = true
                    }
                }.inPad()
                .btColor(.accentColor)
                .onAppear {
                    withAnimation(Animation.default.delay(0.25)) {
                        showPass = true
                        
                    }
                }.animation(.none)
            } else if errorX == "EXTRACT" {
                VIButton(id: "NEVER-HAPPENING", h: .constant("MUHAHAHA")) {
                    Image("PackageCircle")
                    Text("Extracting Package")
                }.inPad()
                .btColor(.gray)
                .onAppear {
                    DispatchQueue.global(qos: .background).async {
                        extractPackage(installInfo: installInfo!, password: password, errorX: { errorX = $0 }, beta: { isBeta = $0 })
                    }
                }
            } else if errorX == "CREATE" {
                VIButton(id: "NEVER-HAPPENING", h: .constant("MUHAHAHA")) {
                    Image("DriveCircle")
                    Text("Creating Installer")
                }.inPad()
                .btColor(.gray)
                .onAppear {
                    DispatchQueue.global(qos: .background).async {
                        createInstallMedia(volume: volume, installInfo: installInfo!, password: password, progressText: { progressText = $0 }, errorX: { errorX = $0 })
                    }
                }
                Text(progressText)
                    .font(.caption)
                    .lineLimit(2)
            } else if errorX == "PATCH" {
                VIButton(id: "NEVER-HAPPENING", h: .constant("MUHAHAHA")) {
                    Image("ToolsCircle")
                    Text("Patching Installer")
                }.inPad()
                .btColor(.gray)
                .onAppear {
                    DispatchQueue.global(qos: .background).async {
                        patchInstaller(password: password, progressText: { progressText = $0 }, errorX: { errorX = $0 })
                    }
                }
                Text(progressText)
                    .font(.caption)
                    .lineLimit(2)
            } else if errorX == "DONE" {
                Text("Done!")
                    .bold()
                    .onAppear {
                        withAnimation {
                            p = .done
                        }
                    }
            } else {
                VIError(errorX)
            }
        }
    }
}