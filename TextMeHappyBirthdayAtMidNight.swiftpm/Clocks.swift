//
//  Clocks.swift
//  test418-TimeDevelopmenet
//
//  Created by KimJS on 2023/04/18.
//

import SwiftUI

struct ClockOfJessicaView: View {
    
    @ObservedObject var timeData : TimeData

    @Binding var sizeOfView : CGSize
    
    @State private var lengthOfT: Double = 0.0
    
    private func calculateAngleOfHour(hour: Int) -> Angle {
        if hour == 12 { return .zero }
        else {
            return Angle(degrees: Double(hour * 30))
        }
    }
    
    let allNumberData: [OffsetData] = [
        OffsetData(x: 1/2, y: -3.squareRoot()/2, index: 1) , // 1
        OffsetData(x: 3.squareRoot()/2, y: -1/2, index: 2), // 2
        OffsetData(x: 1,y: 0, index: 3), // 3
        OffsetData(x:3.squareRoot()/2, y:1/2, index:4), // 4
        OffsetData(x:1/2, y:3.squareRoot()/2, index:5), // 5
        OffsetData(x:0, y:1, index:6), // 6
        OffsetData(x:-1/2, y:3.squareRoot()/2, index:7), // 7
        OffsetData(x:-3.squareRoot()/2, y:1/2, index:8), // 8
        OffsetData(x:-1, y:0, index:9), // 9
        OffsetData(x:-3.squareRoot()/2, y:-1/2, index:10), // 10
        OffsetData(x:-1/2, y:-3.squareRoot()/2, index:11), // 11
        OffsetData(x:0, y:-1, index:12) // 12
    ]
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(timeData.isJessicaSun ? .white : .black)
                .animation(.linear(duration: 0.2), value: timeData.isJessicaSun)
                .onAppear {
                    lengthOfT = sizeOfView.height/15
                }
            
            ForEach(allNumberData) { value in
                NumberOfJessicaView(timeData: timeData, number: value.index, fontsize: lengthOfT * 5 / 16)
                    .offset(x: lengthOfT * value.x, y: lengthOfT * value.y)
            }
            
            RoundedRectangle(cornerRadius: 30)
                .fill(timeData.isJessicaSun ? Color.black : Color.white)
                .frame(width: 11 * lengthOfT / 328, height: 0.7 * lengthOfT)
                .rotationEffect(Angle(degrees: Double(timeData.numbersOfJessicaTime[.hour] ?? 0) * 30), anchor: .bottom)
                .offset(y: -0.35 * lengthOfT)
            
            Circle()
                .fill(timeData.isJessicaSun ? Color.black : Color.white)
                .frame(width: 0.1 * lengthOfT, height: 0.1 * lengthOfT)
            
        }
    }
}

struct ClockOfMinsooView: View {
    
    @ObservedObject var timeData : TimeData
    
    @Binding var sizeOfView : CGSize
    
    @State private var lengthOfT: Double = 0.0
    
    let allNumberData: [OffsetData] = [
        OffsetData(x: 1/2, y: -3.squareRoot()/2, index: 1) , // 1
        OffsetData(x: 3.squareRoot()/2, y: -1/2, index: 2), // 2
        OffsetData(x: 1,y: 0, index: 3), // 3
        OffsetData(x:3.squareRoot()/2, y:1/2, index:4), // 4
        OffsetData(x:1/2, y:3.squareRoot()/2, index:5), // 5
        OffsetData(x:0, y:1, index:6), // 6
        OffsetData(x:-1/2, y:3.squareRoot()/2, index:7), // 7
        OffsetData(x:-3.squareRoot()/2, y:1/2, index:8), // 8
        OffsetData(x:-1, y:0, index:9), // 9
        OffsetData(x:-3.squareRoot()/2, y:-1/2, index:10), // 10
        OffsetData(x:-1/2, y:-3.squareRoot()/2, index:11), // 11
        OffsetData(x:0, y:-1, index:12) // 12
    ]
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(timeData.isMinsooSun ? .white : .black)
                .animation(.linear(duration: 0.2), value: timeData.isMinsooSun)
                .onAppear {
                    lengthOfT = sizeOfView.height/15
                }
            
            ForEach(allNumberData) { value in
                NumberOfMinsooView(timeData: timeData, number: value.index, fontsize: lengthOfT * 5 / 16)
                    .offset(x: lengthOfT * value.x, y: lengthOfT * value.y)
            }
            
            RoundedRectangle(cornerRadius: 30)
                .fill(timeData.isMinsooSun ? Color.black : Color.white)
                .frame(width: 11 * lengthOfT / 328, height: 0.7 * lengthOfT)
                .rotationEffect(Angle(degrees: Double(timeData.numbersOfMinsooTime[.hour] ?? 0) * 30), anchor: .bottom)
                .offset(y: -0.35 * lengthOfT)
            
            Circle()
                .fill(timeData.isMinsooSun ? Color.black : Color.white)
                .frame(width: 0.1 * lengthOfT, height: 0.1 * lengthOfT)
            
        }
    }
}

struct NumberOfJessicaView: View {
    @ObservedObject var timeData : TimeData
    
    let number : Int
    let fontsize: CGFloat
    
    var body: some View {
        Text("\(number)")
            .font(.system(size: fontsize))
            .foregroundColor(timeData.isJessicaSun ? .black : .white)
    }
}

struct NumberOfMinsooView: View {
    @ObservedObject var timeData : TimeData
    
    let number : Int
    let fontsize: CGFloat
    
    var body: some View {
        Text("\(number)")
            .font(.system(size: fontsize))
            .foregroundColor(timeData.isMinsooSun ? .black : .white)
    }
}

struct OffsetData : Identifiable {
    let x : CGFloat
    let y : CGFloat
    let index : Int
    let id = UUID()
}

