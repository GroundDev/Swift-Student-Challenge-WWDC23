import SwiftUI

@available(iOS 16.0, *)
struct UniverseView: View {
    enum AllGestureState {
        case inactive
        case pressing
        case dragging(startLocation : CGPoint, finalLocation : CGPoint)
        
        var startLocation: CGPoint {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let startLocation, _):
                return startLocation
            }
        }
        
        var finalLocation: CGPoint {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(_, let finalLocation):
                return finalLocation
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive, .pressing:
                return false
            case .dragging:
                return true
            }
        }
    }
    
    @StateObject private var timeData = TimeData()
    
    @GestureState private var earthState : AllGestureState = .inactive
    
    // 아이패드 화면 전체의 사이즈
    @State private var sizeOfView : CGSize = .zero
    
    // 모달, alert창 제어하는 변수
    @State private var isSimpleExplanationPresented: Bool = true
    
    var body: some View {
        
        let minimumPressDuration : Double = 0.01
        let pressDrag = LongPressGesture(minimumDuration: minimumPressDuration)
            .sequenced(before: DragGesture())
            .updating($earthState) { currentState, gestureState, transaction in
                switch currentState {
                case .first(true):
                    gestureState = .pressing
                case .second(true, let value):
                    gestureState = .dragging(startLocation: value?.startLocation ?? .zero, finalLocation: value?.location ?? .zero)
                default:
                    gestureState = .inactive
                }
            }
            .onChanged { value in
                guard case .second(true, let drag?) = value else { return }
                
                var initialAngle = Double(atan2(drag.startLocation.x - sizeOfView.height/4, sizeOfView.height/4 - drag.startLocation.y) * 180 / Double.pi)
                var finalAngle = Double(atan2(drag.location.x-sizeOfView.height/4, sizeOfView.height/4-drag.location.y) * 180 / Double.pi)
                initialAngle = initialAngle < 0 ? initialAngle + 360 : initialAngle
                finalAngle = finalAngle < 0 ? finalAngle + 360 : finalAngle
                
                if (timeData.pastFinalLocation.x < sizeOfView.height/4) && (timeData.pastFinalLocation.y < sizeOfView.height/4) && (drag.location.x >= sizeOfView.height/4) && (drag.location.y < sizeOfView.height/4) && (timeData.pastFinalLocation.x != .zero) {
                    timeData.flagGoRight += 1
                }
                if (timeData.pastFinalLocation.x >= sizeOfView.height/4) && (timeData.pastFinalLocation.y < sizeOfView.height/4) && (drag.location.x < sizeOfView.height/4) && (drag.location.y < sizeOfView.height/4) {
                    timeData.flagGoLeft += 1
                }
                
                timeData.dragAngleOfEarth = timeData.totalAngleOfEarth + finalAngle - initialAngle + (timeData.flagGoRight - timeData.flagGoLeft) * 360
                timeData.hourIncrement = Int(-timeData.dragAngleOfEarth/15)
                
                if timeData.hourIncrement > timeData.pastHourIncrement {
                    timeData.timeOfMinsooDate = Calendar.current.date(byAdding: .hour, value: +1, to: timeData.timeOfMinsooDate) ?? timeData.timeOfMinsooDate
                    timeData.timeOfJessicaDate = Calendar.current.date(byAdding: .hour, value: +1, to: timeData.timeOfJessicaDate) ?? timeData.timeOfMinsooDate
                    timeData.pastHourIncrement = timeData.hourIncrement
                }
                if timeData.hourIncrement < timeData.pastHourIncrement {
                    timeData.timeOfMinsooDate = Calendar.current.date(byAdding: .hour, value: -1, to: timeData.timeOfMinsooDate) ?? timeData.timeOfMinsooDate
                    timeData.timeOfJessicaDate = Calendar.current.date(byAdding: .hour, value: -1, to: timeData.timeOfJessicaDate) ?? timeData.timeOfMinsooDate
                    timeData.pastHourIncrement = timeData.hourIncrement
                }
                
                // 이제 바뀐 date 값을 업데이트 해서 string 변환하고 number로 바꿔서 저장하자
                self.timeData.extractNumberFromStringOfJessica()
                self.timeData.extractNumberFromStringOfMinsoo()
                
                self.timeData.setIsJessicaAM()
                self.timeData.setIsMinsooAM()
                self.timeData.setIsJessicaSun()
                self.timeData.setIsMinsooSun()
                
                timeData.pastFinalLocation = drag.location
            }
            .onEnded { _ in
                timeData.totalAngleOfEarth = timeData.dragAngleOfEarth
                timeData.flagGoLeft = .zero
                timeData.flagGoRight = .zero
            }
        
        // 사실상의 메인 전체 뷰
        ZStack {
            // 배경 은하수
            Image("imageOfMilkyOriginal")
                .resizable()
                .ignoresSafeArea()
            
            // 좌상단 태양
            Circle()
                .fill(.radialGradient(colors: [.yellow, .red], center: UnitPoint(x: 0.5, y: 0.5), startRadius: sizeOfView.height/6, endRadius: sizeOfView.height/2)
                )
                .blur(radius: 3)
                .shadow(color: .red, radius: 100)
                .offset(x:-sizeOfView.width/4, y:-3*sizeOfView.height/4)
                .frame(width: sizeOfView.height, height: sizeOfView.height)
            
            // 좌하단 지구 관련된 뷰
            ZStack {
                Image("imageOfRealEarth")
                    .resizable()
                    .clipShape(Circle())
                    .shadow(color: .blue, radius: earthState.isDragging ? 80 : 0)
                    .rotationEffect(.degrees(timeData.dragAngleOfEarth))
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Gradient(colors: [.clear, .black, .black, .black, .black]))
                        .frame(height: sizeOfView.height/4)
                }
                .clipShape(Circle())
                .opacity(0.7)
                
                // 지구본 위 시작 민수 위치점
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 30,height: 30)
                    Circle()
                        .foregroundColor(.blue)
                        .frame(width: 15,height: 15)
                }
                .opacity(earthState.isDragging ? 1 : 0.5)
                .offset(x:-sin(15 * Double.pi / 180) * (sizeOfView.height/4), y:-cos(15 * Double.pi / 180) * (sizeOfView.height/4))
                .rotationEffect(.degrees(timeData.dragAngleOfEarth))
                // 지구본 위 시작 제시카 위치점
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 30,height: 30)
                    Circle()
                        .foregroundColor(.yellow)
                        .frame(width: 15,height: 15)
                }
                .opacity(earthState.isDragging ? 1 : 0.5)
                .offset(x:sin(75 * Double.pi / 180) * (sizeOfView.height/4), y:-cos(75 * Double.pi / 180) * (sizeOfView.height/4))
                .rotationEffect(.degrees(timeData.dragAngleOfEarth))
            }
            .gesture(pressDrag)
            .offset(x: -sizeOfView.width/4, y: sizeOfView.height/8)
            .frame(width: sizeOfView.height/2, height: sizeOfView.height/2)
            .animation(.default, value: earthState.isDragging)
            
            // 우상단 시계 뷰 모음
            HStack {
                VStack {
                    Text("Kuwait City")
                        .foregroundColor(.white)
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.yellow, lineWidth: 5)
                            .opacity(earthState.isDragging ? 1 : 0.5)
                            .animation(.default, value: earthState.isDragging)
                            .frame(width: 2*sizeOfView.height/9, height:4*sizeOfView.height/15)
                        VStack(spacing: sizeOfView.height/50) {
                            ClockOfJessicaView(timeData: timeData, sizeOfView: $sizeOfView)
                                .frame(width: sizeOfView.height/6, height: sizeOfView.height/6)
                            HStack {
                                Text("\(timeData.numberToMonthString(month: timeData.numbersOfJessicaTime[.month] ?? 1)) \(timeData.numbersOfJessicaTime[.day] ?? 1),")
                                Text( "\(timeData.makeTwoDigitOfJessicaHour()):00")
                            }
                            .foregroundColor(.white)
                        }
                    }
                }
                VStack {
                    Text("Seoul")
                        .foregroundColor(.white)
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.blueOfiMessage, lineWidth: 5)
                            .opacity(earthState.isDragging ? 1 : 0.5)
                            .animation(.default, value: earthState.isDragging)
                            .frame(width: 2*sizeOfView.height/9, height:4*sizeOfView.height/15)
                        VStack(spacing: sizeOfView.height/50) {
                            ClockOfMinsooView(timeData: timeData, sizeOfView: $sizeOfView)
                                .frame(width: sizeOfView.height/6, height: sizeOfView.height/6)
                            Text("\(timeData.numberToMonthString(month: timeData.numbersOfMinsooTime[.month] ?? 1)) \(timeData.numbersOfMinsooTime[.day] ?? 1),  \(timeData.makeTwoDigitOfMinsooHour()):00")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .offset(x: sizeOfView.width/4, y:-sizeOfView.height/3)
            
            // 우하단 메시지 뷰
            MessageView(timeData: timeData ,sizeOfView: $sizeOfView)
                .frame(width: 2*sizeOfView.height/3, height: 2*sizeOfView.height/3)
                .offset(x: sizeOfView.width/4, y: sizeOfView.height/6)
            
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        sizeOfView = geometry.size
                        timeData.calendarOfMinsooJessicaMaker()
                        timeData.extractNumberFromStringOfMinsoo()
                        timeData.extractNumberFromStringOfJessica()
                    }
            }
        }
        .sheet(isPresented: $isSimpleExplanationPresented) {
            SimpleExplanationView()
        }
    }
}
