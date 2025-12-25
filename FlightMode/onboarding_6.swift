//
//  onboarding_6.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 20.12.2025.
//

import SwiftUI


final class PhysicsContainerView: UIView {
    
    private lazy var animator = UIDynamicAnimator(referenceView: self)
    
    private let gravity = UIGravityBehavior()
    private let collision = UICollisionBehavior()
    private let itemBehavior = UIDynamicItemBehavior()
    
    var onTapMissionCallback: ((Mission) -> ())?
    
    private var hostedViews: [Mission: UIView] = [:]
    
    private var confirmView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhysics()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func setupPhysics() {
        backgroundColor = .clear
        collision.translatesReferenceBoundsIntoBoundary = true
        gravity.magnitude = 2
        itemBehavior.elasticity = 0.2
        itemBehavior.density = 1000
        itemBehavior.friction = 0.1
        itemBehavior.resistance = 0.0
        itemBehavior.allowsRotation = true
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(itemBehavior)
    }
    
    func addFalling(content: PhysicsContent) {
        let hostingController = UIHostingController(rootView: content.view)
        hostingController.view.frame = CGRect(
            x: content.startX + CGFloat.random(in: -20...20),
            y: content.startY,
            width: content.width,
            height: content.height
        )
        hostingController.view.backgroundColor = .clear

        addSubview(hostingController.view)
        
        if let mission = content.mission {
            hostedViews[mission] = hostingController.view
        }

        gravity.addItem(hostingController.view)
        collision.addItem(hostingController.view)
        itemBehavior.addItem(hostingController.view)
    }
    
    func addStaticObject<Content: View>(swiftUIView: Content, width: Double, height: Double, startX: Double, startY: Double) {
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.frame = CGRect(
            x: startX,
            y: startY,
            width: width,
            height: height
        )
        hostingController.view.backgroundColor = .clear
        
        confirmView = hostingController.view

        addSubview(hostingController.view)

        let bounderyPath = UIBezierPath(rect: hostingController.view.frame)
        collision.addBoundary(withIdentifier: "staticObject" as NSCopying, for: bounderyPath)
    }
    
    func remove(mission: Mission) {
        if let view = hostedViews[mission] {
            gravity.removeItem(view)
            collision.removeItem(view)
            itemBehavior.removeItem(view)
            view.removeFromSuperview()
            hostedViews.removeValue(forKey: mission)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print(point)
        for mission in hostedViews.keys {
            let view = hostedViews[mission]!
            let convertedPoint = view.convert(point, from: self)
            if view.point(inside: convertedPoint, with: event) {
                onTapMissionCallback?(mission)
                remove(mission: mission)
                return view
            }
        }
        if let view = confirmView {
            let convertedPoint = view.convert(point, from: self)
            if view.point(inside: convertedPoint, with: event) {
                return view
            }
        }
        return nil
    }
}


struct PhysicsContent {
    var view: AnyView?
    var startX: Double
    var startY: Double
    var width: Double
    var height: Double
    var mission: Mission?
}


struct PhysicsView: UIViewRepresentable {
    
    @Binding var contentToDrop: PhysicsContent?
    @Binding var staticContent: PhysicsContent?
    
    var onTapMissionCallback: ((Mission) -> ())
    
    func makeUIView(context: Context) -> PhysicsContainerView {
        let view = PhysicsContainerView()
        view.onTapMissionCallback = onTapMissionCallback
        return view
    }
    
    func updateUIView(_ uiView: PhysicsContainerView, context: Context) {
        if let content = contentToDrop {
            uiView.addFalling(content: content)
            
            DispatchQueue.main.async {
                contentToDrop = nil
            }
        }
        if let content = staticContent {
            uiView.addStaticObject(swiftUIView: content.view, width: content.width, height: content.height, startX: content.startX, startY: content.startY)
            
            DispatchQueue.main.async {
                staticContent = nil
            }
        }
    }
}


struct MissionButtonView: View {
    
    var mission: Mission
    @Binding var contentToDrop: PhysicsContent?
    @Binding var selectedMissions: [Mission]
    var width: Double
    var height: Double
    var startX: Double
    var startY: Double
    
    var body: some View {
        if !selectedMissions.contains(mission) {
            Button(action: {
                if selectedMissions.contains(mission) {
                    selectedMissions.removeAll { mis in
                        mis == mission
                    }
                } else {
                    selectedMissions.append(mission)
                    contentToDrop = PhysicsContent(view: AnyView(self), startX: startX, startY: startY, width: width, height: height, mission: mission)
                }
            }, label: {
                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        Text(mission.emoji)
                            .font(.custom("Montserrat", size: 14))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Text(mission.name)
                            .font(.custom("Montserrat", size: 14))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.all, 20)
            })
            .frame(width: width, height: height, alignment: .center)
            .glassEffect(.regular.tint(selectedMissions.contains(mission) ? Color(hex: "FFAE17") : .clear), in: RoundedRectangle(cornerRadius: height / 2))
        } else {
            ZStack {
                Color(hex: "FFAE17")
                    .opacity(0.5)
                    .clipShape(RoundedRectangle(cornerRadius: height/2))
                Button(action: {
                    if selectedMissions.contains(mission) {
                        selectedMissions.removeAll { mis in
                            mis == mission
                        }
                    } else {
                        selectedMissions.append(mission)
                        contentToDrop = PhysicsContent(view: AnyView(self), startX: startX, startY: startY, width: width, height: height, mission: mission)
                    }
                }, label: {
                    VStack(alignment: .center) {
                        HStack(alignment: .center) {
                            Text(mission.emoji)
                                .font(.custom("Montserrat", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text(mission.name)
                                .font(.custom("Montserrat", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.all, 20)
                })
                .frame(width: width, height: height, alignment: .center)
                .background(.clear)
                .clipShape(RoundedRectangle(cornerRadius: height/2))
                .overlay {
                    RoundedRectangle(cornerRadius: height / 2).stroke(Color(hex: "FFAE17"), lineWidth: 2)
                }
            }
        }
    }
}

struct OnboardingScreenSixth : View {
    
    @EnvironmentObject var router: Router
    
    @State private var contentToDrop: PhysicsContent?
    @State private var staticContent: PhysicsContent?
    @State private var selectedMissions: [Mission] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        router.navigateBack()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .padding(.all, 6)
                    })
                    .buttonBorderShape(.circle)
                    .buttonStyle(GlassButtonStyle())
                    .font(.system(size: 24))
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    HStack {
                        Text("SELECT YOUR")
                            .font(.custom("Wattauchimma", size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    HStack {
                        Text("FLIGHT MISSIONS")
                            .font(.custom("Wattauchimma", size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "FFAE17"))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    Text("Сhoose at least one mission to begin your flight.")
                        .font(.custom("Montserrat", size: 14))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(0..<Int(ceil(Double(Mission.allCases.count) / 3.0)), id: \.self) { i in
                            HStack(alignment: .top, spacing: 10) {
                                ForEach(0..<3, id: \.self) { j in
                                    if i * 3 + j < Mission.allCases.count && !selectedMissions.contains(Mission.allCases[3 * i + j]) {
                                        MissionButtonView(mission: Mission.allCases[3 * i + j], contentToDrop: $contentToDrop, selectedMissions: $selectedMissions, width: geometry.size.width * 0.3, height: 60, startX: 20.0 + Double(j) * (geometry.size.width + 10.0) * 0.3, startY: Double(i) * Double(80) + geometry.safeAreaInsets.top + 160.0 + 80)
                                    } else {
                                        VStack {
                                            
                                        }
                                        .frame(width: geometry.size.width * 0.3, height: 60)
                                    }
                                }
                            }
                        }
                    }
//                    .frame(maxWidth: geometry.size.width - 40)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                PhysicsView(contentToDrop: $contentToDrop, staticContent: $staticContent, onTapMissionCallback: { mission in
                    print(mission.name)
                    selectedMissions.removeAll{ $0 == mission }
                })
                    .frame(width: geometry.size.width, height: geometry.size.height)
//                .ignoresSafeArea()
            }
            .onAppear {
                DispatchQueue.main.async {
                    staticContent = PhysicsContent(view: AnyView(
                        Button(action: {
                            if selectedMissions.count > 0 {
                                router.navigate(to: Route.onboarding(Route.OnboardingScreen.seventh))
                            }
                        }, label: {
                            Text("Confirm")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                        })
                        .contentShape(.rect)
                        .glassEffect(.clear.tint(Color(hex: selectedMissions.count > 0 ? "FFAE17" : "3D3D3D")).interactive())
                    ), startX: 20, startY: geometry.size.height - 80.0, width: geometry.size.width - 40, height: 60)
                }
            }
            .onChange(of: selectedMissions) {
                DispatchQueue.main.async {
                    staticContent = PhysicsContent(view: AnyView(
                        Button(action: {
                            if selectedMissions.count > 0 {
                                router.navigate(to: Route.onboarding(Route.OnboardingScreen.seventh))
                            }
                        }, label: {
                            Text("Confirm")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                        })
                        .contentShape(.rect)
                        .glassEffect(.clear.tint(Color(hex: selectedMissions.count > 0 ? "FFAE17" : "3D3D3D")).interactive())
                    ), startX: 20, startY: geometry.size.height - 80.0, width: geometry.size.width - 40, height: 60)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0E0E0E"))
    }
}


#Preview {
    OnboardingScreenSixth()
}
