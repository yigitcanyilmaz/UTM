//
// Copyright © 2020 osy. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

// Lots of dirty hacks to work around SwiftUI bugs introduced in Beta 2
struct VMToolbarModifier: ViewModifier {
    let bottom: Bool
    let editAction: () -> Void
    @EnvironmentObject private var data: UTMData
    
    #if os(macOS)
    let destructiveButtonColor: Color = .primary
    let buttonPlacement: ToolbarItemPlacement = .automatic
    let padding: Int = 0
    #else
    let destructiveButtonColor: Color = .red
    var buttonPlacement: ToolbarItemPlacement {
        if bottom {
            return .bottomBar
        } else {
            return .navigationBarTrailing
        }
    }
    var spacerPlacement: ToolbarItemPlacement {
        if bottom {
            return .bottomBar
        } else {
            return .status // FIXME: hack around SwiftUI bug
        }
    }
    var padding: CGFloat {
        if bottom {
            return 0
        } else {
            return 10
        }
    }
    #endif
    
    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: buttonPlacement) {
                Button {
                    
                } label: {
                    Label("Delete", systemImage: "trash")
                        .foregroundColor(destructiveButtonColor)
                        .labelStyle(IconOnlyLabelStyle())
                }.help("Delete selected VM")
                .padding(.leading, padding)
            }
            #if !os(macOS)
            ToolbarItem(placement: spacerPlacement) {
                Spacer()
            }
            #endif
            ToolbarItem(placement: buttonPlacement) {
                Button {
                    
                } label: {
                    Label("Clone", systemImage: "doc.on.doc")
                        .labelStyle(IconOnlyLabelStyle())
                }.help("Clone selected VM")
                .padding(.leading, padding)
            }
            #if !os(macOS)
            ToolbarItem(placement: spacerPlacement) {
                Spacer()
            }
            #endif
            ToolbarItem(placement: buttonPlacement) {
                Button {
                    
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .labelStyle(IconOnlyLabelStyle())
                }.help("Share selected VM")
                .padding(.leading, padding)
            }
            #if !os(macOS)
            ToolbarItem(placement: spacerPlacement) {
                Spacer()
            }
            #endif
            ToolbarItem(placement: buttonPlacement) {
                Button {
                    data.run(vm: data.selectedVM!)
                } label: {
                    Label("Run", systemImage: "play.fill")
                        .labelStyle(IconOnlyLabelStyle())
                }.help("Run selected VM")
                .padding(.leading, padding)
            }
            #if !os(macOS)
            ToolbarItem(placement: spacerPlacement) {
                Spacer()
            }
            #endif
            ToolbarItem(placement: buttonPlacement) {
                Button(action: editAction) {
                    Label("Edit", systemImage: "slider.horizontal.3")
                        .labelStyle(IconOnlyLabelStyle())
                }.help("Edit selected VM")
                .padding(.leading, padding)
            }
        }
    }
}
