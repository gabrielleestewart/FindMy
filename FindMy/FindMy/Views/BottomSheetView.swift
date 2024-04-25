//
//  BottomSheetView.swift
//  FindMy
//
//  Created by Gabrielle Stewart on 4/17/24.
//
import SwiftUI
import MapKit
import CoreLocation

extension View {
    @ViewBuilder
    // Default Tab Bar height = 49.
    func bottomMaskForSheet(mask: Bool = true, _ height: CGFloat = 49) -> some View {
        self
            .background(SheetRootViewFinder(mask: mask, height: height))
    }
}

extension UIView {
    func allSubViews() -> [UIView] {
        var allViews = [self]
        subviews.forEach { allViews.append(contentsOf: $0.allSubViews()) }
        return allViews
    }
}

fileprivate struct SheetRootViewFinder: UIViewRepresentable {
    var mask: Bool
    var height: CGFloat
    func makeUIView(context: Context) -> UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let rootView = uiView.viewBeforeWindow, let window = rootView.window {
                let safeArea = window.safeAreaInsets
                rootView.frame = .init(
                    origin: .zero,
                    size: .init(
                        width: window.frame.width,
                        height: window.frame.height - (mask ? (height + safeArea.bottom) : 0)
                    )
                )
                
                rootView.clipsToBounds = true
                for view in rootView.subviews {
                    //Removing Shadows
                    view.layer.shadowColor = UIColor.clear.cgColor
                    
                    if let animationKeys = view.layer.animationKeys(),
                       let cornerRadiusView = rootView.allSubViews().first(where: { _ in animationKeys.contains("cornerRadius") }) {
                        cornerRadiusView.layer.maskedCorners = []
                    }
                }
            }
        }
    }
}

fileprivate extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        return superview?.viewBeforeWindow
    }
}


struct BottomSheetView: View {
    @StateObject var locationViewModel = DeviceLocationViewModel()
    @State private var showSheet: Bool = true
    @State private var activeTab: Tab = .people
    @State private var ignoreTabBar: Bool = false
    
    var deviceViewModel: DeviceListViewModel
    var personViewModel: PersonListViewModel
    var itemViewModel: ItemListViewModel
    
    init(deviceViewModel: DeviceListViewModel, personViewModel: PersonListViewModel, itemViewModel: ItemListViewModel) {
        self.deviceViewModel = deviceViewModel
        self.personViewModel = personViewModel
        self.itemViewModel = itemViewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            MapView()
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    let chapelHillCoordinate = CLLocationCoordinate2D(latitude: 35.90948, longitude: -79.05086)
                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    locationViewModel.region = MKCoordinateRegion(center: chapelHillCoordinate, span: span)
                }
            
            TabBar()
                .frame(height: 49)
                .background(.regularMaterial)
                .background(Color.white.opacity(0.6))
        }
        .task {
            showSheet = true
            //locationViewModel.requestLocationUpdates()
        }
        .sheet(isPresented: $showSheet) {
            ScrollView(.vertical, content: {
                VStack(alignment: .leading, spacing: 15, content: {
                    activeTab.data
                })
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .presentationDetents([.height(50), .medium, .large])
            .presentationCornerRadius(20)
            .presentationBackground(Color.white.opacity(0.8))
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .presentationContentInteraction(.resizes)
            .interactiveDismissDisabled()
            // Add it inside Sheet View
            .bottomMaskForSheet(mask: !ignoreTabBar)
        }
    }
    
    @ViewBuilder
    func TabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Button(action: { activeTab = tab }, label: {
                    VStack(spacing: 2) {
                        Image(systemName: tab.symbol)
                            .font(.title2)
                        
                        Text(tab.rawValue)
                            .font(.caption2)
                    }
                    .padding(.top, 10)
                    .foregroundStyle(activeTab == tab ? Color.accentColor: .gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                })
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}


enum Tab: String, CaseIterable {
    case people = "People"
    case devices = "Devices"
    case items = "Items"
    case me = "Me"
    
    var symbol: String {
        switch self {
        case .people:
            "figure.2"
        case .devices:
            "macbook.and.iphone"
        case .items:
            "circle.grid.2x2.fill"
        case .me:
            "person.circle.fill"
        }
    }
    var data: some View {
        switch self {
        case .people:
            return AnyView(PeopleListView(viewModel: PersonListViewModel()))
        case .devices:
            return AnyView(DevicesListView(viewModel: DeviceListViewModel()))
        case .items:
            return AnyView(ItemsListView(viewModel: ItemListViewModel()))
        case .me:
            return AnyView(MeView())
        }
    }
}

#Preview {
    BottomSheetView(deviceViewModel: DeviceListViewModel(), personViewModel: PersonListViewModel(), itemViewModel: ItemListViewModel())
}
