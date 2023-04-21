//
//  TimeData.swift
//  test418-TimeDevelopmenet
//
//  Created by KimJS on 2023/04/18.
//

import Foundation

class TimeData: ObservableObject {

    // 시간대의 Date 값들. 아래의 세팅하는 함수들로 인해 맥락상 유효한 초기값이 형성된다.
    @Published var timeOfMinsooDate: Date = .init(timeIntervalSince1970: 0)
    @Published var timeOfJessicaDate: Date = .now
    
    // 지구본 회전 관련 변수들
    @Published var dragAngleOfEarth: Double = .zero
    @Published var totalAngleOfEarth: Double = .zero
    @Published var pastFinalLocation: CGPoint = .zero
    @Published var flagGoRight: Double = .zero
    @Published var flagGoLeft: Double = .zero
    @Published var hourIncrement: Int = .zero
    @Published var pastHourIncrement: Int = .zero
    
    // 정수로 바로바로 꺼내 먹을 수 있는 시간정보들
    var numbersOfMinsooTime: [TimeDataSet: Int] = [:]
    var numbersOfJessicaTime: [TimeDataSet: Int] = [:]
    
    // 각각이 AM인지를 얻을 수 있는 property
    var isJessicaAM: Bool = true
    var isMinsooAM: Bool = true
    
    // 해가 떠 있는지 달이 떠 있는지를 얻을 수 있는 property
    var isJessicaSun: Bool = true
    var isMinsooSun: Bool = true
    
    // 민수가 만일 지금 결정을 내린다면 빠른건지 늦은건지 정답인지를 얻을 수 있는 property
    var decesionStateOfMinsoo: DecisionStateOfMinsoo = .earlyButOneDayIn
    
    // 제시카의 생일 자정을 뜻하는 Date 값
    var accurateJessicaBD: Date = .now
    // 제시카의 생일 자정으로부터 24시간이 지난 이후의 Date 값
    var accurateJessicaBDNext: Date = .now
    // 제시카의 생일 자정으로부터 24시간 이전의 Date 값
    var accurateJessicaBDPrevious: Date = .now
    
    // extract 함수 내에서 시작지점에 호출되는 서브 함수들
    func dateToStringOfMinsoo() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withDay, .withMonth, .withYear, .withTime ,.withSpaceBetweenDateAndTime]
        let stringOfDate = formatter.string(from: self.timeOfMinsooDate)
        return stringOfDate
    }
    func dateToStringOfJessica() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withDay, .withMonth, .withYear, .withTime ,.withSpaceBetweenDateAndTime]
        let stringOfDate = formatter.string(from: self.timeOfJessicaDate)
        return stringOfDate
    }
    
    // 드래그 할 때마다 date에서부터 numbers를 업데이트 하는 함수들
    func extractNumberFromStringOfMinsoo() -> Void {
        let stringOfDate = self.dateToStringOfMinsoo()
        let splited = stringOfDate.split(separator: " ")
        
        let intOfFirstString = Int(splited[0])
        if let intOfFirstString = intOfFirstString {
            let year = intOfFirstString / 10000
            let day = intOfFirstString % 100
            let month = (intOfFirstString - 10000*year - day ) / 100
            
            self.numbersOfMinsooTime.updateValue(year, forKey: .year)
            self.numbersOfMinsooTime.updateValue(day, forKey: .day)
            self.numbersOfMinsooTime.updateValue(month, forKey: .month)
        }
        
        let intOfSecondString = Int(splited[1])
        if let intOfSecondString = intOfSecondString {
            let hour = intOfSecondString / 10000
            
            self.numbersOfMinsooTime.updateValue(hour, forKey: .hour)
        }
    }
    func extractNumberFromStringOfJessica() -> Void {
        let stringOfDate = self.dateToStringOfJessica()
        let splited = stringOfDate.split(separator: " ")
        
        let intOfFirstString = Int(splited[0])
        if let intOfFirstString = intOfFirstString {
            let year = intOfFirstString / 10000
            let day = intOfFirstString % 100
            let month = (intOfFirstString - 10000*year - day ) / 100
            
            self.numbersOfJessicaTime.updateValue(year, forKey: .year)
            self.numbersOfJessicaTime.updateValue(day, forKey: .day)
            self.numbersOfJessicaTime.updateValue(month, forKey: .month)
        }
        
        let intOfSecondString = Int(splited[1])
        if let intOfSecondString = intOfSecondString {
            let hour = intOfSecondString / 10000
            
            self.numbersOfJessicaTime.updateValue(hour, forKey: .hour)
        }
    }
    
    // 시간 데이터 세팅하는 함수
    func calendarOfMinsooJessicaMaker() -> Void {
        let isoDateFormatter = ISO8601DateFormatter()
        
        //밑을 주석처리하면 그냥 gmt 시간대로 배정되는 듯
//        isoDateFormatter.timeZone = .current
        
        isoDateFormatter.formatOptions = [.withDay, .withMonth, .withYear, .withTime ,.withSpaceBetweenDateAndTime]
        self.timeOfMinsooDate = isoDateFormatter.date(from: "20230604 130000") ?? .now
        self.timeOfJessicaDate = isoDateFormatter.date(from: "20230604 070000") ?? .now
        
        // 제시카의 정확한 생일 시각을 업데이트한다
        self.setAccurateJessicaBD()
        self.setAccurateJessicaBDNext()
        self.setAccurateJessicaBDPrevious()
    }
    
    // 각각이 AM인지 알 수 있는 property를 업데이트하는 함수
    func setIsJessicaAM() -> Void {
        let hour = self.numbersOfJessicaTime[.hour]
        if let hour = hour {
            if (hour >= 0) && (hour < 12) {
                self.isJessicaAM = true
            } else {
                self.isJessicaAM = false
            }
        }
    }
    func setIsMinsooAM() -> Void {
        let hour = self.numbersOfMinsooTime[.hour]
        if let hour = hour {
            if (hour >= 0) && (hour < 12) {
                self.isMinsooAM = true
            } else {
                self.isMinsooAM = false
            }
        }
    }
    
    // 해가 떠 있는 시간인지, 달이 떠 있는 시간인지에 관한 property를 업데이트 하는 함수
    func setIsJessicaSun() -> Void {
        let hour = self.numbersOfJessicaTime[.hour]
        if let hour = hour {
            if (hour >= 5) && (hour < 19) {
                self.isJessicaSun = true
            } else {
                self.isJessicaSun = false
            }
        }
    }
    func setIsMinsooSun() -> Void {
        let hour = self.numbersOfMinsooTime[.hour]
        if let hour = hour {
            if (hour >= 5) && (hour < 19) {
                self.isMinsooSun = true
            } else {
                self.isMinsooSun = false
            }
        }
    }
    
    // 민수의 결정에 대한 값을 업데이트하는 함수
    func setDecisionStateOfMinsoo() -> Void {
        let date = self.timeOfJessicaDate
        if (date < self.accurateJessicaBDPrevious) {
            self.decesionStateOfMinsoo = .earlyMore
        } else if (date >= self.accurateJessicaBDPrevious) && (date < self.accurateJessicaBD) {
            self.decesionStateOfMinsoo = .earlyButOneDayIn
        } else if (date > self.accurateJessicaBD) && (date < self.accurateJessicaBDNext) {
            self.decesionStateOfMinsoo = .lateButOneDayIn
        } else if (date >= self.accurateJessicaBDNext) {
            self.decesionStateOfMinsoo = .lateMore
        } else if (date == self.accurateJessicaBD) {
            self.decesionStateOfMinsoo = .answer
        }
    }
    
    // 제시카의 생일 시각을 업데이트하는 함수. 최초로 한 번만 호출된다.
    func setAccurateJessicaBD() -> Void {
        self.accurateJessicaBD = Calendar.current.date(byAdding: .hour, value: +17, to: timeOfJessicaDate) ?? timeOfJessicaDate
        print("정확한 날짜 : \(accurateJessicaBD)")
    }
    func setAccurateJessicaBDNext() -> Void {
        self.accurateJessicaBDNext = Calendar.current.date(byAdding: .hour, value: +41, to: timeOfJessicaDate) ?? timeOfJessicaDate
        print("정확한 날짜 + 1: \(accurateJessicaBDNext)")
    }
    func setAccurateJessicaBDPrevious() -> Void {
        self.accurateJessicaBDPrevious = Calendar.current.date(byAdding: .hour, value: -7, to: timeOfJessicaDate) ?? timeOfJessicaDate
        print("정확한 날짜 - 1: \(accurateJessicaBDPrevious)")
    }
    
    // 메시지 좌상단의 시계에 숫자 앞자리 0 채워서 문자열 반환하는 함수
    func makeTwoDigitOfMinsooHour() -> String {
        let hour = self.numbersOfMinsooTime[.hour]
        if let hour = hour {
            if (hour >= 0 ) && (hour < 10) {
                return "0" + "\(hour)"
            } else {
                return "\(hour)"
            }
        } else {
            return ""
        }
    }
    // 위의 시계 표현에도 쓰기 위해 중복한 형태로 선언
    func makeTwoDigitOfJessicaHour() -> String {
        let hour = self.numbersOfJessicaTime[.hour]
        if let hour = hour {
            if (hour >= 0 ) && (hour < 10) {
                return "0" + "\(hour)"
            } else {
                return "\(hour)"
            }
        } else {
            return ""
        }
    }
    
    // 숫자를 주면 String의 월 값을 반환하는 함수
    func numberToMonthString(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
}

// 시간에 관련된 정보들의 목록을 나열한 enum
enum TimeDataSet {
    case year
    case month
    case day
    case hour
}

// 민수가 내리는 결정들이 가질 수 있는 결과값들을 모아둔 enum
enum DecisionStateOfMinsoo {
    case answer
    case earlyButOneDayIn
    case earlyMore
    case lateButOneDayIn
    case lateMore
}
