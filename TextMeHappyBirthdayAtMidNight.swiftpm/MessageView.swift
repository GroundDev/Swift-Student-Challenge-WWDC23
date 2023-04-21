//
//  MessageView.swift
//  test418-TimeDevelopmenet
//
//  Created by KimJS on 2023/04/19.
//

import SwiftUI

struct MessageView : View {
    
    @ObservedObject var timeData : TimeData
    @Binding var sizeOfView : CGSize
    
    @State private var isJessicaInformationModalPresented : Bool = false
    
    var body: some View {
        
        ZStack {
            Color.white
            
            // 제일 위의 뒷 배경
            Rectangle()
                .foregroundColor(.grayBackgroundOfiMessage)
                .frame(width: 2*sizeOfView.height/3, height: sizeOfView.height/6)
                .offset(x:0, y:-sizeOfView.height/4)
            
            // 좌상단 시계
            Text(timeData.makeTwoDigitOfMinsooHour() + ":00")
                .offset(x:-sizeOfView.height/4.5, y:-14*sizeOfView.height/48)
            
            // Dynamic island
            Rectangle()
                .cornerRadius(50)
                .frame(width: sizeOfView.height/4, height: sizeOfView.height/25)
                .offset(x:0, y:-14*sizeOfView.height/48)
            
            // 우상단 배터리 등등
            HStack(spacing: sizeOfView.height/100) {
                Label("", systemImage: "wifi")
                Label("", systemImage: "battery.100")
            }
            .offset(x: sizeOfView.height/4.3, y: -14*sizeOfView.height/48)
            
            // 프로필 (전체가 버튼)
            Button {
                self.isJessicaInformationModalPresented.toggle()
            } label: {
                VStack {
                    Image("imageOfJessica")
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width: sizeOfView.height/14, height: sizeOfView.height/14)
                    HStack {
                        Text("Jessica")
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.gray)
                    }
                }
            }
            .font(.caption)
            .foregroundColor(.black)
            .offset(x:0, y:-11*sizeOfView.height/48)
            
            MessageContentView(timeData: timeData, sizeOfView: $sizeOfView)
                .frame(width: 2*sizeOfView.height/3, height: sizeOfView.height/2)
                .offset(x:0, y:sizeOfView.height/12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .sheet(isPresented: $isJessicaInformationModalPresented) {
            JessicaInformationView()
        }
    }
}

struct MessageContentView : View {
    
    @ObservedObject var timeData : TimeData
    @Binding var sizeOfView : CGSize
    
    func actOfSendButton() -> Void {
        self.isNewDatePresented.toggle()
        selectedHour = timeData.numbersOfMinsooTime[.hour] ?? 0
        selectedisAM = timeData.isMinsooAM
        
        // messages 최초의 값 업데이트
        messages.append(MessageCell(sender: .minsoo, message: "Happy birthday, Jessica 🥳"))
        // 민수가 제대로 선택했는지의 값 업데이트
        timeData.setDecisionStateOfMinsoo()
        
        // 결정의 상태에 따라 messages에 들어가는 값이 달라짐
        switch timeData.decesionStateOfMinsoo {
        case .answer: // 정답일 때
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(2))) {
                messages.append(MessageCell(sender: .jessica, message: "Thank you🤩"))
            }
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(4))) {
                messages.append(MessageCell(sender: .jessica, message: "I love you so much!😍😘🥰"))
            }
        case .earlyButOneDayIn: // 생일보다 더 빠르지만 하루 이내의 오차
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(2))) {
                messages.append(MessageCell(sender: .jessica, message: "Oh, tomorrow!🤣 tomorrow is my birthday. You were very close"))
            }
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(4))) {
                messages.append(MessageCell(sender: .jessica, message: "Anyway, thank you for your celebration!"))
            }
        case .earlyMore: // 생일보다 하루 초과의 빠름
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(2))) {
                messages.append(MessageCell(sender: .jessica, message: "Oh, not yet!🤣 But thank you!"))
            }
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(4))) {
                messages.append(MessageCell(sender: .jessica, message: "May you celebrate me at the midnight of my birthday once more?"))
            }
        case .lateButOneDayIn: // 생일보다 더 느리지만 하루 이내의 오차
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(2))) {
                messages.append(MessageCell(sender: .jessica, message: "Oh, Thank you!🤩"))
            }
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(4))) {
                messages.append(MessageCell(sender: .jessica, message: "Of course I appreciate your celebration, but next time may you celebrate me at the midnight? I want it 😏"))
            }
        case .lateMore: // 생일보다 하루 초과의 느림
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(2))) {
                messages.append(MessageCell(sender: .jessica, message: "Oh, dear. My birthday already flies away🤣"))
            }
            DispatchQueue.main.schedule(after: .init(.now() + .seconds(4))) {
                messages.append(MessageCell(sender: .jessica, message: "But that means you're thinking about me, right? Thank you haha"))
            }
        }
    }
    
    let oldMessages: [MessageCell] = [
        MessageCell(sender: .minsoo, message: "I'm in Seoul. How are you?"),
        MessageCell(sender: .jessica, message: "Oh, Minsoo! I'm in Kuwait. It's great! 😆"),
        MessageCell(sender: .jessica, message: "Please text me happy birthday at the midnight of my birthday 🙂. I mean, the beginning of the day!")
    ]
    
    @State var messages: [MessageCell] = []
    
    // 유저가 전송을 누르는 순간 true가 되는 property
    @State private var isNewDatePresented: Bool = false
    
    // 유저가 전송을 누르는 순간 저장되는 보낸 시각, 보낸 시각의 AM 유무
    @State private var selectedHour: Int = 0
    @State private var selectedisAM: Bool = true
    
    var body: some View {
        
        ScrollView(showsIndicators: true) {
            VStack {
                
                // 아래의 뷰들은 바뀌지 않는 뷰들
                Text("iMessage")
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
                    .font(.footnote)
                    .padding(.top)
                Text("Fri, Feb 24")
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
                    .font(.footnote)
                + Text(" 9:41 AM")
                    .foregroundColor(.gray)
                    .fontWeight(.light)
                    .font(.footnote)
                ForEach(oldMessages) { message in
                    HStack {
                        if message.sender == SenderOfMessage.jessica {
                            MessageBallonView(sizeOfView: $sizeOfView, message: message.message, sender: message.sender)
                            Spacer()
                        } else {
                            Spacer()
                            MessageBallonView(sizeOfView: $sizeOfView, message: message.message, sender: message.sender)
                        }
                    }
                }
                
                // 아래의 뷰들은 사용자가 버튼을 누르면 나옴
                if isNewDatePresented {
                    HStack(spacing: 2) {
                        Text("Today")
                            .fontWeight(.medium)
                        Text(" \(selectedHour):00 \(selectedisAM ? "AM" : "PM")")
                            .fontWeight(.light)
                    }
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.top)
                    
                    // 새롭게 업데이트 된 messages를 표현
                    ForEach(messages) { message in
                        HStack {
                            if message.sender == SenderOfMessage.jessica {
                                MessageBallonView(sizeOfView: $sizeOfView, message: message.message, sender: message.sender)
                                Spacer()
                            } else {
                                Spacer()
                                MessageBallonView(sizeOfView: $sizeOfView, message: message.message, sender: message.sender)
                            }
                        }
                    }
                    
                    // 모든 것을 다시 초기화하는 버튼
                    Button {
                        AppState.shared.thisAppID = UUID()
                    } label: {
                        Label("Try again", systemImage: "arrow.uturn.left.circle")
                    }
                    .foregroundColor(.blueOfiMessage)
                    .padding()
                }
                
                Spacer()
                
                // 하단 사용자 Input 뷰. 한번 쏴지고 맘
                if (!isNewDatePresented) {
                    HStack {
                        Spacer()
                        HStack(spacing: sizeOfView.height/10) {
                            Text("Happy birthday, Jessica 🥳")
                                .padding(.leading)
                            Button {
                                actOfSendButton()
                            } label: {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.largeTitle)
                            }
                            .foregroundColor(.blueOfiMessage)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.grayBottomBackgroundOfiMessage, lineWidth: 1)
                        }
                        .padding([.top, .trailing])
                    }
                }
            }
        }
        .animation(.default, value: messages)
    }
}

struct MessageBallonView : View {
    @Binding var sizeOfView : CGSize
    
    let message : String
    let sender : SenderOfMessage
    
    var body: some View {
        Text(message)
            .padding()
            .background(sender == SenderOfMessage.jessica ? Color.grayOfiMessage : Color.blueOfiMessage)
            .foregroundColor(sender == SenderOfMessage.jessica ? .black : .white)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay(alignment: sender == SenderOfMessage.jessica ? .bottomLeading : .bottomTrailing) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title)
                    .rotationEffect(sender == SenderOfMessage.jessica ? Angle(degrees: 45) : Angle(degrees: -45))
                    .foregroundColor(sender == SenderOfMessage.jessica ? .grayOfiMessage : .blueOfiMessage)
                    .offset(x:sender == SenderOfMessage.jessica ? -4 : 4, y:4)
            }
            .padding([.leading, .trailing], 20)
    }
}

struct MessageCell : Identifiable {
    let sender : SenderOfMessage
    let message: String
    let id = UUID()
}

extension MessageCell : Equatable {
    static func == (lhs: MessageCell, rhs: MessageCell) -> Bool {
        return lhs.sender == rhs.sender && lhs.message == rhs.message && lhs.id == rhs.id
    }
}

enum SenderOfMessage {
    case jessica
    case minsoo
}
