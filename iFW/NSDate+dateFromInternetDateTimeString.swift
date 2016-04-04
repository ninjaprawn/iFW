//  Adapted from an example by Thibaut LE LEVIER on 05/09/2014.


import UIKit

extension NSDate {

    class var internetDateFormatter : NSDateFormatter {
        struct Static {
            static let instance: NSDateFormatter = {
                let dateFormatter = NSDateFormatter()
                let locale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
                dateFormatter.locale = locale
                dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                return dateFormatter
            }()
        }
        return Static.instance
    }

    class func dateFromInternetDateTimeString(dateString: String!) -> NSDate?
    {
        var date: NSDate? = nil
		
		if dateString == "Mon, 30 Nov -0001 00:00:00 GMT" {
			return nil
		}

        date = NSDate.dateFromRFC822String(dateString)

        if date == nil
        {
            date = NSDate.dateFromRFC3339String(dateString)
        }

        return date
    }

    class func dateFromRFC822String(dateString: String!) -> NSDate?
    {
        var date: NSDate? = nil

        let rfc822_string: NSString = dateString.uppercaseString

        if rfc822_string.rangeOfString(",").location != NSNotFound
        {
            if date == nil
            {
                NSDate.internetDateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"

                date = NSDate.internetDateFormatter.dateFromString(rfc822_string as String)
            }

            if date == nil
            {
                NSDate.internetDateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm zzz"

                date = NSDate.internetDateFormatter.dateFromString(rfc822_string as String)
            }

            if date == nil
            {
                NSDate.internetDateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss"

                date = NSDate.internetDateFormatter.dateFromString(rfc822_string as String)
            }

            if date == nil
            {
                NSDate.internetDateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm"

                date = NSDate.internetDateFormatter.dateFromString(rfc822_string as String)
            }
        }
        else
        {
            if date == nil
            {
                NSDate.internetDateFormatter.dateFormat = "d MMM yyyy HH:mm:ss zzz"

                date = NSDate.internetDateFormatter.dateFromString(rfc822_string as String)
            }

            if date == nil
            {
                NSDate.internetDateFormatter.dateFormat = "d MMM yyyy HH:mm zzz"

                date = NSDate.internetDateFormatter.dateFromString(rfc822_string as String)
            }

            if date == nil
            {
                NSDate.internetDateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"

                date = NSDate.internetDateFormatter.dateFromString(rfc822_string as String)
            }

            if date == nil
            {
                NSDate.internetDateFormatter.dateFormat = "d MMM yyyy HH:mm"

                date = NSDate.internetDateFormatter.dateFromString(rfc822_string as String)
            }
        }

        return date
    }

    class func dateFromRFC3339String(dateString: String!) -> NSDate?
    {
        var date: NSDate? = nil

        var rfc3339_string: NSString = dateString.uppercaseString

        if rfc3339_string.length > 20
        {
            rfc3339_string = rfc3339_string.stringByReplacingOccurrencesOfString(":", withString: "", options: .CaseInsensitiveSearch, range: NSMakeRange(20, rfc3339_string.length-20))
        }

        if date == nil
        {
            NSDate.internetDateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"

            date = NSDate.internetDateFormatter.dateFromString(rfc3339_string as String)
        }

        if date == nil // this case may need more work
        {
            NSDate.internetDateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"

            date = NSDate.internetDateFormatter.dateFromString(rfc3339_string as String)
        }

        if date == nil
        {
            NSDate.internetDateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"

            date = NSDate.internetDateFormatter.dateFromString(rfc3339_string as String)
        }

        return date
    }
    
}
