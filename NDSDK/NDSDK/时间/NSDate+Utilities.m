//
//  NSDate+Utilities.m
//  IOS-Categories
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "NSDate+Utilities.h"
#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]
@implementation NSDate (Utilities)

#pragma mark Relative Dates
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}
+ (NSDate *) dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}
+ (NSDate *) dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
#pragma mark Comparing Dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}
- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}
- (BOOL) isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}
- (BOOL) isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}
// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfYear != components2.weekOfYear) return NO;
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}
- (BOOL) isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}
- (BOOL) isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}
- (BOOL) isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}
// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}
- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}
- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
    return (components1.year == components2.year);
}
- (BOOL) isThisYear
{
    // Thanks, baspellis
    return [self isSameYearAsDate:[NSDate date]];
}
- (BOOL) isNextYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
    return (components1.year == (components2.year + 1));
}
- (BOOL) isLastYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
    return (components1.year == (components2.year - 1));
}
- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}
- (BOOL) isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}
// Thanks, markrickert
- (BOOL) isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}
// Thanks, markrickert
- (BOOL) isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}
#pragma mark Roles
- (BOOL) isTypicallyWeekend
{
    NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}
- (BOOL) isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}
#pragma mark Adjusting Dates
- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}
- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
    return [self dateByAddingHours: (dHours * -1)];
}
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}
- (NSDate *) dateAtStartOfDay
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [CURRENT_CALENDAR dateFromComponents:components];
}
- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
    return dTime;
}
#pragma mark Retrieving Intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}
- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}
- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}
- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}
- (NSInteger) daysAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}
- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}
// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0];
    return components.day;
}
#pragma mark Decomposing Dates
- (NSInteger) nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
    return components.hour;
}
- (NSInteger) hour
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}
- (NSInteger) minute
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}
- (NSInteger) seconds
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.second;
}
- (NSInteger) day
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}
- (NSInteger) month
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}
- (NSInteger) week
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekOfYear;
}
- (NSInteger) weekday
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekday;
}
- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekdayOrdinal;
}
- (NSInteger) year
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.year;
}


/**********************************************************
 *@Description:获取当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 *@Params:nil
 *@Return:当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 ***********************************************************/
- (NSDateComponents *)componentsOfDay
{
    static NSDateComponents *dateComponents = nil;
    static NSDate *previousDate = nil;
    
    if (!previousDate || ![previousDate isEqualToDate:self]) {
        previousDate = self;
        dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    }
    
    return dateComponents;
}


//  --------------------------NSDate---------------------------
- (NSInteger)weekdayOrdinal
{
    return self.weekdayOrdinal;
}




/******************************************
 *@Description:获取当天的起始时间（00:00:00）
 *@Params:nil
 *@Return:当天的起始时间
 ******************************************/
- (NSDate *)beginingOfDay
{
    [[self componentsOfDay] setHour:0];
    [[self componentsOfDay] setMinute:0];
    [[self componentsOfDay] setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}

/******************************************
 *@Description:获取当天的结束时间（23:59:59）
 *@Params:nil
 *@Return:当天的结束时间
 ******************************************/
- (NSDate *)endOfDay
{
    [[self componentsOfDay] setHour:23];
    [[self componentsOfDay] setMinute:59];
    [[self componentsOfDay] setSecond:59];
    
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}

/******************************************
 *@Description:获取当月的第一天
 *@Params:nil
 *@Return:当月的第一天
 ******************************************/
- (NSDate *)firstDayOfTheMonth
{
    [[self componentsOfDay] setDay:1];
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}

/******************************************
 *@Description:获取当月的最后一天
 *@Params:nil
 *@Return:当月的最后一天
 ******************************************/
- (NSDate *)lastDayOfTheMonth
{
    [[self componentsOfDay] setDay:[self numberOfDaysInMonth]];
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}

/******************************************
 *@Description:获取前一个月的第一天
 *@Params:nil
 *@Return:前一个月的第一天
 ******************************************/
- (NSDate *)firstDayOfThePreviousMonth
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    
    return [[[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0] firstDayOfTheMonth];
}

/******************************************
 *@Description:获取后一个月的第一天
 *@Params:nil
 *@Return:后一个月的第一天
 ******************************************/
- (NSDate *)firstDayOfTheFollowingMonth
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    
    return [[[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0] firstDayOfTheMonth];
}


/******************************************
 *@Description:获取前一个月中与当天对应的日期
 *@Params:nil
 *@Return:前一个月中与当天对应的日期
 ******************************************/
- (NSDate *)associateDayOfThePreviousMonth
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

/******************************************
 *@Description:获取后一个月中与当天对应的日期
 *@Params:nil
 *@Return:后一个月中与当天对应的日期
 ******************************************/
- (NSDate *)associateDayOfTheFollowingMonth
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}


/******************************************
 *@Description:获取当月的天数
 *@Params:nil
 *@Return:当月的天数
 ******************************************/
- (NSUInteger)numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}


/******************************************
 *@Description:获取当月的周数
 *@Params:nil
 *@Return:当月的周数
 ******************************************/
- (NSUInteger)numberOfWeeksInMonth
{
    NSUInteger weekOfFirstDay = [[self firstDayOfTheMonth] componentsOfDay].weekday;
    NSUInteger numberDaysInMonth = [self numberOfDaysInMonth];
    
    return ((weekOfFirstDay - 1 + numberDaysInMonth) % 7) ? ((weekOfFirstDay - 1 + numberDaysInMonth) / 7 + 1): ((weekOfFirstDay - 1 + numberDaysInMonth) / 7);
}


/******************************************
 *@Description:获取这一周的第一天
 *@Params:nil
 *@Return:这一周的第一天
 ******************************************/
- (NSDate *)firstDayOfTheWeek
{
    NSDate *firstDay = nil;
    if ([[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit startDate:&firstDay interval:NULL forDate:self]) {
        return firstDay;
    }
    
    return firstDay;
}

/******************************************
 *@Description:获取当月中，前一周的第一天
 *@Params:nil
 *@Return:前一周的第一天
 ******************************************/
- (NSDate *)firstDayOfThePreviousWeekInTheMonth
{
    NSDate *firstDayOfTheWeekInTheMonth = [self firstDayOfTheWeekInTheMonth];
    if ([firstDayOfTheWeekInTheMonth componentsOfDay].weekday > 1) {
        return nil;
    } else {
        if ([firstDayOfTheWeekInTheMonth componentsOfDay].day > 7) {
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.day = -7;
            return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
        } else if ([firstDayOfTheWeekInTheMonth componentsOfDay].day > 1) {
            return [self firstDayOfTheMonth];
        } else {
            return nil;
        }
    }
}

/******************************************
 *@Description:获取前一个月中，最后一周的第一天
 *@Params:nil
 *@Return:前一个月中，最后一周的第一天
 ******************************************/
- (NSDate *)firstDayOfTheLastWeekInPreviousMonth
{
    NSDate *firstDayOfThePreviousMonth = [self firstDayOfThePreviousMonth];
    NSUInteger numberOfDaysInPreviousMonth = [firstDayOfThePreviousMonth numberOfDaysInMonth];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = [firstDayOfThePreviousMonth componentsOfDay].year;
    components.month = [firstDayOfThePreviousMonth componentsOfDay].month;
    components.day = numberOfDaysInPreviousMonth;
    NSDate *lastDayOfThePreviousMonth = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return [lastDayOfThePreviousMonth firstDayOfTheWeekInTheMonth];
}


/******************************************
 *@Description:获取当月中，后一周的第一天
 *@Params:nil
 *@Return:后一周的第一天
 ******************************************/
- (NSDate *)firstDayOfTheFollowingWeekInTheMonth
{
    NSDate *firstDayOfTheWeekInTheMonth = [self firstDayOfTheWeekInTheMonth];
    NSUInteger numberOfDaysInMonth = [self numberOfDaysInMonth];
    if (([firstDayOfTheWeekInTheMonth componentsOfDay].day + 6) >= numberOfDaysInMonth) {
        return nil;
    } else {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = 6;
        return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
    }
}

/******************************************
 *@Description:获取下一个月中，最前一周的第一天
 *@Params:nil
 *@Return:下一个月中，最前一周的第一天
 ******************************************/
- (NSDate *)firstDayOfTheFirstWeekInFollowingMonth
{
    NSDate *firstDayOfTheFollowingMonth = [self firstDayOfTheFollowingMonth];
    
    return [firstDayOfTheFollowingMonth firstDayOfTheWeekInTheMonth];
}


/******************************************
 *@Description:获取当月中，这一周的第一天
 *@Params:nil
 *@Return:当月中，这一周的第一天
 ******************************************/
- (NSDate *)firstDayOfTheWeekInTheMonth
{
    NSDate *firstDayOfTheWeek = nil;
    if ([[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit startDate:&firstDayOfTheWeek interval:NULL forDate:self]) {
        NSDate *firstDayOfTheMonth = [self firstDayOfTheMonth];
        if ([firstDayOfTheWeek componentsOfDay].month == [firstDayOfTheMonth componentsOfDay].month) {
            return firstDayOfTheWeek;
        } else {
            return firstDayOfTheMonth;
        }
    }
    
    return firstDayOfTheWeek;
}


/******************************************
 *@Description:获取当月中，这一周的天数
 *@Params:nil
 *@Return:当月中，这一周的天数
 ******************************************/
- (NSUInteger)numberOfDaysInTheWeekInMonth
{
    NSDate *firstDayOfTheWeek = [self firstDayOfTheWeek];
    NSDate *firstDayOfTheWeekInTheMonth = [self firstDayOfTheWeekInTheMonth];
    
    if ([firstDayOfTheWeek componentsOfDay].month == [firstDayOfTheWeekInTheMonth componentsOfDay].month) {
        return (firstDayOfTheWeek.numberOfDaysInMonth - [firstDayOfTheWeek componentsOfDay].day + 1) >= 7 ? 7 : (firstDayOfTheWeek.numberOfDaysInMonth - [firstDayOfTheWeek componentsOfDay].day + 1);
    } else {
        return (8 - [firstDayOfTheWeekInTheMonth componentsOfDay].weekday);
    }
}

/******************************************
 *@Description:获取当天是当月的第几周
 *@Params:nil
 *@Return:当天是当月的第几周
 ******************************************/
- (NSUInteger)weekOfDayInMonth
{
    NSDate *firstDayOfTheMonth = [self firstDayOfTheMonth];
    NSUInteger weekdayOfFirstDayOfTheMonth = [firstDayOfTheMonth componentsOfDay].weekday;
    NSUInteger day = [self componentsOfDay].day;
    
    return ((day + weekdayOfFirstDayOfTheMonth - 1)%7) ? ((day + weekdayOfFirstDayOfTheMonth - 1)/7) + 1: ((day + weekdayOfFirstDayOfTheMonth - 1)/7);
}

/******************************************
 *@Description:获取当天是当年的第几周
 *@Params:nil
 *@Return:当天是当年的第几周
 ******************************************/
- (NSUInteger)weekOfDayInYear
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSWeekOfYearCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
}

/******************************************
 *@Description:获取前一周中与当天对应的日期
 *@Params:nil
 *@Return:前一个周中与当天对应的日期
 ******************************************/
- (NSDate *)associateDayOfThePreviousWeek
{
    NSUInteger day = [self componentsOfDay].day;
    NSUInteger weekday = [self componentsOfDay].weekday;
    
    if (day > 7) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = -7;
        
        return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
    } else if (day > weekday) {
        
        return [self firstDayOfTheMonth];
    } else {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = -1;
        
        return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[self firstDayOfTheWeekInTheMonth] options:0];
    }
}

/******************************************
 *@Description:获取后一周中与当天对应的日期
 *@Params:nil
 *@Return:后一周中与当天对应的日期
 ******************************************/
- (NSDate *)associateDayOfTheFollowingWeek
{
    NSUInteger numberOfDaysInMonth = [self numberOfDaysInMonth];
    NSUInteger day = [self componentsOfDay].day;
    NSUInteger weekday = [self componentsOfDay].weekday;
    if (day + 7 <= numberOfDaysInMonth) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = 7;
        
        return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
    } else if ((day + (7 - weekday + 1)) <= numberOfDaysInMonth) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = numberOfDaysInMonth - day;
        
        return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
    } else {
        return [self firstDayOfTheFollowingMonth];
    }
}


/******************************************
 *@Description:前一天
 *@Params:nil
 *@Return:前一天
 ******************************************/
- (NSDate *)previousDay
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}



/******************************************
 *@Description:后一天
 *@Params:nil
 *@Return:后一天
 ******************************************/
- (NSDate *)followingDay
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}


/******************************************
 *@Description:判断与某一天是否为同一天
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一天；NO-不同一天
 ******************************************/
- (BOOL)sameDayWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year && self.month == otherDate.month && self.day == otherDate.day) {
        return YES;
    } else {
        return NO;
    }
}


/******************************************
 *@Description:判断与某一天是否为同一周
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一周；NO-不同一周
 ******************************************/
- (BOOL)sameWeekWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year  && self.month == otherDate.month && self.weekOfDayInYear == otherDate.weekOfDayInYear) {
        return YES;
    } else {
        return NO;
    }
}

/******************************************
 *@Description:判断与某一天是否为同一月
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一月；NO-不同一月
 ******************************************/
- (BOOL)sameMonthWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year && self.month == otherDate.month) {
        return YES;
    } else {
        return NO;
    }
}





@end