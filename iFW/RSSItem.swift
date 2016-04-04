//  Adapted from an example by Thibaut LE LEVIER on 05/09/2014.

import UIKit

class RSSItem: NSObject, NSCoding {
    var title: String?
    var links: [NSURL] = []
    var propertyIDs: [String] = []

    func addLink(linkString: String?)
    {
        if let _ = linkString, let l = NSURL(string: linkString!) {
            links.append(l)
        }
    }
    func addPropertyID(propertyID: String?)
    {
        if let _ = propertyID {
            propertyIDs.append(propertyID!)
        }
    }

    var guid: String?
    var pubDate: NSDate?

    func setPubDate1(let dateString: String!)
    {
        pubDate = NSDate.dateFromInternetDateTimeString(dateString)
    }

    var itemDescription: String?
    var content: String?

    // Wordpress specifics
    var commentsLink: NSURL?

    func setCommentsLink1(let linkString: String!)
    {
        commentsLink = NSURL(string: linkString)
    }

    var commentsCount: Int?

    var commentRSSLink: NSURL?

    func setCommentRSSLink1(let linkString: String!)
    {
        commentRSSLink = NSURL(string: linkString)
    }

    var author: String?

    var categories: [String]! = [String]()

    var imagesFromItemDescription: [NSURL]! {
        if let itemDescription = self.itemDescription
        {
            return itemDescription.imageLinksFromHTMLString
        }

        return [NSURL]()
    }

    var imagesFromContent: [NSURL]! {
        if let content = self.content
        {
            return content.imageLinksFromHTMLString
        }

        return [NSURL]()
    }

    override init()
    {
        super.init()
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder)
    {
        super.init()

        title = aDecoder.decodeObjectForKey("title") as? String
        //        links = aDecoder.decodeObjectForKey("links") as? NSURL
        guid = aDecoder.decodeObjectForKey("guid") as? String
        pubDate = aDecoder.decodeObjectForKey("pubDate") as? NSDate
        itemDescription = aDecoder.decodeObjectForKey("description") as? String
        content = aDecoder.decodeObjectForKey("content") as? String
        commentsLink = aDecoder.decodeObjectForKey("commentsLink") as? NSURL
        commentsCount = aDecoder.decodeObjectForKey("commentsCount") as? Int
        commentRSSLink = aDecoder.decodeObjectForKey("commentRSSLink") as? NSURL
        author = aDecoder.decodeObjectForKey("author") as? String
        categories = aDecoder.decodeObjectForKey("categories") as? [String]
    }

    func encodeWithCoder(aCoder: NSCoder)
    {
        if let title = self.title
        {
            aCoder.encodeObject(title, forKey: "title")
        }

        //        if let link = self.link
        //        {
        //            aCoder.encodeObject(link, forKey: "link")
        //        }

        if let guid = self.guid
        {
            aCoder.encodeObject(guid, forKey: "guid")
        }

        if let pubDate = self.pubDate
        {
            aCoder.encodeObject(pubDate, forKey: "pubDate")
        }

        if let itemDescription = self.itemDescription
        {
            aCoder.encodeObject(itemDescription, forKey: "description")
        }

        if let content = self.content
        {
            aCoder.encodeObject(content, forKey: "content")
        }

        if let commentsLink = self.commentsLink
        {
            aCoder.encodeObject(commentsLink, forKey: "commentsLink")
        }

        if let commentsCount = self.commentsCount
        {
            aCoder.encodeObject(commentsCount, forKey: "commentsCount")
        }

        if let commentRSSLink = self.commentRSSLink
        {
            aCoder.encodeObject(commentRSSLink, forKey: "commentRSSLink")
        }

        if let author = self.author
        {
            aCoder.encodeObject(author, forKey: "author")
        }

        aCoder.encodeObject(categories, forKey: "categories")
    }
}