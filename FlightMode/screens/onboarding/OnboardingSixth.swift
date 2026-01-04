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
        itemBehavior.friction = 0.2
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
        
        confirmView?.removeFromSuperview()
        
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
        collision.removeBoundary(withIdentifier: "staticObject" as NSCopying)
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
    
    class Coordinator {
        var addingMissions: [Mission] = []
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> PhysicsContainerView {
        let view = PhysicsContainerView()
        view.onTapMissionCallback = onTapMissionCallback
        return view
    }
    
    func updateUIView(_ uiView: PhysicsContainerView, context: Context) {
        if let content = contentToDrop {
            if !context.coordinator.addingMissions.contains(content.mission!) {
                context.coordinator.addingMissions.append(content.mission!)
                uiView.addFalling(content: content)
                DispatchQueue.main.async {
                    contentToDrop = nil
                    context.coordinator.addingMissions.removeAll { $0 == content.mission! }
                }
            }
        }
        if let content = staticContent {
            DispatchQueue.main.async {
                uiView.addStaticObject(swiftUIView: content.view, width: content.width, height: content.height, startX: content.startX, startY: content.startY)
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
            if #available(iOS 26, *) {
                Button(action: {
                    if (selectedMissions.count < 5) {
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
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: height / 2))
            } else {
                Button(action: {
                    if (selectedMissions.count < 5) {
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
                .background(Color(hex: "0E0E0E").opacity(0.8))
                .background(LinearGradient(gradient: Gradient(colors: [
                    Color(hex: "EBF0FF").opacity(0.6),
                    Color(hex: "C8CCFF").opacity(0.5),
                    Color(hex: "D9D7FF").opacity(0.4),
                ]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(height / 2)
            }
        } else {
            ZStack {
                Color(hex: "FFAE17")
                    .opacity(0.5)
                    .clipShape(RoundedRectangle(cornerRadius: height/2))
                Button(action: {
                    selectedMissions.removeAll { mis in
                        mis == mission
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
    
    @State private var confirmButtonView: AnyView?
    
    @EnvironmentObject var user: UserModel
    
    private func updateConfirmButton(height: Double, width: Double) {
        
        if #available(iOS 26, *) {
            confirmButtonView = AnyView(
                Button(action: {
                    if selectedMissions.count == 5 {
                        user.setFavoriteMission(missions: selectedMissions)
                        router.navigate(to: Route.onboarding(Route.OnboardingScreen.seventh))
                    }
                }, label: {
                    Text("Confirm")
                        .font(.custom("Montserrat", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                })
                .contentShape(.rect)
                .glassEffect(.regular.tint(Color(hex: selectedMissions.count == 5 ? "FFAE17" : "3D3D3D")).interactive())
            )
        } else {
            confirmButtonView = AnyView(
                Button(action: {
                    if selectedMissions.count == 5 {
                        router.navigate(to: Route.onboarding(Route.OnboardingScreen.seventh))
                    }
                }, label: {
                    Text("Confirm")
                        .font(.custom("Montserrat", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                })
                .buttonStyle(CustomButtonStyle(color: Color(hex: selectedMissions.count == 5 ? "FFAE17" : "3D3D3D").opacity(0.7)))
                )
        }
        
        staticContent = PhysicsContent(view: confirmButtonView, startX: 20, startY: height - 60.0, width: width - 40, height: 60)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                    if #available(iOS 26, *) {
                        Button(action: {
                            router.navigateBack()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .padding(.all, 6)
                        })
                        .buttonBorderShape(.circle)
                        .buttonStyle(GlassButtonStyle())
                        .padding(.horizontal, 20)
                    } else {
                        Button(action: {
                            router.navigateBack()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .padding(.all, 6)
                        })
                        .foregroundStyle(.white)
                        .buttonBorderShape(.circle)
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 20)
                    }
                    HStack {
                        Text("SELECT YOUR")
                            .font(.custom("Wattauchimma", size: 44))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    HStack {
                        Text("FLIGHT MISSIONS")
                            .font(.custom("Wattauchimma", size: 44))
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "FFAE17"))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    Text("Сhoose five missions to begin your flight.")
                        .font(.custom("Montserrat", size: 18))
                        .fontWeight(.regular)
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
                VStack(alignment: .trailing) {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "FFA600").opacity(0.35),
                                    .clear
                                ]), center: .center, startRadius: 0, endRadius: Double(100 + selectedMissions.count * 80)
                            )
                        )
                        .frame(width: Double(200 + selectedMissions.count * 16), height: Double(200 + selectedMissions.count * 16))
                        .blur(radius: Double(60 + selectedMissions.count * 2))
                        .offset(x: Double(100 + selectedMissions.count * 8), y: Double(100 + selectedMissions.count * 8))
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottomTrailing)
                PhysicsView(contentToDrop: $contentToDrop, staticContent: $staticContent, onTapMissionCallback: { mission in
                    selectedMissions.removeAll{ $0 == mission }
                    print(selectedMissions)
                })
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .onAppear {
                if geometry.size.width != 0 && geometry.size.height != 0 {
                    updateConfirmButton(height: geometry.size.height, width: geometry.size.width)
                }
            }
            .onChange(of: selectedMissions) {
                if geometry.size.width != 0 && geometry.size.height != 0 {
                    updateConfirmButton(height: geometry.size.height, width: geometry.size.width)
                }
            }
            .onChange(of: geometry.size) {
                if geometry.size.width != 0 && geometry.size.height != 0 {
                    updateConfirmButton(height: geometry.size.height, width: geometry.size.width)
                }
            }
            .sensoryFeedback(.impact(weight: .medium), trigger: selectedMissions.count)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0E0E0E"))
    }
}


#Preview {
    OnboardingScreenSixth()
}
