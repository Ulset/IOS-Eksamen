//
//  eksamenTests.swift
//  eksamenTests
//
//  Created by Sander Ulset on 10/11/2021.
//

import XCTest
@testable import eksamen

class eksamenTests: XCTestCase {
    func testShouldHaveBirthday() throws {
        for i in -40...(-20) {
            // I had a problem where based on how many years ago it was, the logic worked sometimes and sometimes not
            // Because of leap years and such, so im testing alot of years
            
            //DateOfBirth only takes string as a date, so need to parse it
            let format = "yyyy-MM-dd"
            let birtDayDate = Calendar.current.date(
              byAdding: .year,
              value: i,
              to: Date())!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            let todaysDateFormatted = dateFormatter.string(from: birtDayDate)
            
            let dateOfBirth = DateOfBirth(date: todaysDateFormatted)
            
            XCTAssertTrue(dateOfBirth.hasBirthdayThisWeek())
        }
    }
    
    func testShouldNotHaveBirthday() throws {
        //Create a Date object a month ago
        let earlyDate = Calendar.current.date(
          byAdding: .month,
          value: -1,
          to: Date())!
        
        //DateOfBirth only takes string as a date, so need to parse it
        let format = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let earlyDateFormatted = dateFormatter.string(from: earlyDate)
        
        let earlyDateOfBirth = DateOfBirth(date: earlyDateFormatted)
        
        XCTAssertFalse(earlyDateOfBirth.hasBirthdayThisWeek())
    }
}
