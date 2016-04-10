
import UIKit

// TODO [DAC] this mixes feed and feed item tags, they should be separated.
enum NodeElement : String {
    case Item = "item"
    case Title = "title"
    case Link = "link"
    case GUID = "guid"
    case PublicationDate = "pubDate"
    case Description = "description"
    case ContentType = "content:encoded"
    case Language = "language"
    case Property = "rdctv:property"
    case ParallaxImage = "rdctv:image"
    case LastBuildDate = "lastBuildDate"
    case Generator = "generator"
    case Copyright = "copyright"
    // Specific to Wordpress:
    case CommentsLink = "comments"
    case CommentsCount = "slash:comments"
    case CommentRSSLink = "wfw:commentsRSS"
    case Author = "dc:creator"
    case Category = "category"
}
extension String {
    func rssNodeElement() -> NodeElement? {
        return NodeElement(rawValue: self)
    }
}

class RSSParser: NSObject, NSXMLParserDelegate {

    class func parseFeedForRequest(request: NSURLRequest, callback: (feed: RSSFeed?, error: NSError?) -> Void)
    {
        let rssParser: RSSParser = RSSParser()

        rssParser.parseFeedForRequest(request, callback: callback)
    }

    static var sharedURLSession : NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

    var callbackClosure: ((feed: RSSFeed?, error: NSError?) -> Void)?
    var currentElement: String = ""
    var currentItem: RSSItem?
    var feed: RSSFeed = RSSFeed()

    func parseFeedForRequest(request: NSURLRequest, callback: (feed: RSSFeed?, error: NSError?) -> Void)
    {
        let theTask = RSSParser.sharedURLSession.dataTaskWithRequest(request) { (data, response, error) -> Void in

            if ((error) != nil)
            {
                callback(feed: nil, error: error)
            }
            else
            {
                self.callbackClosure = callback

                let parser : NSXMLParser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.shouldResolveExternalEntities = false
                parser.parse()
            }
        }
        theTask.resume()
    }

    // MARK: NSXMLParserDelegate
    func parserDidStartDocument(parser: NSXMLParser)
    {
    }

    func parserDidEndDocument(parser: NSXMLParser)
    {
        if let closure = self.callbackClosure
        {
            closure(feed: self.feed, error: nil)
        }
    }

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {

        if let e = elementName.rssNodeElement() where e == .Item
        {
            self.currentItem = RSSItem()
        }

        self.currentElement = ""

    }

    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // Need to have an element that we know how to handle
        guard let element = elementName.rssNodeElement() else { return }

        if let e = elementName.rssNodeElement() where e == .Item
        {
            if let item = self.currentItem
            {
                self.feed.items.append(item)
            }

            self.currentItem = nil
            return
        }

        if let item = self.currentItem
        {
            switch element {

            case .Title :
                item.title = self.currentElement

            case .Link:
                item.addLink(self.currentElement)

            case .Property:
                item.addPropertyID(self.currentElement)

            case .GUID:
                item.guid = self.currentElement

            case .PublicationDate:
                item.setPubDate1(self.currentElement)

            case .Description:
                item.itemDescription = self.currentElement

            case .ContentType:
                item.content = self.currentElement

            case .CommentsLink:
                item.setCommentsLink1(self.currentElement)

            case .CommentsCount:
                item.commentsCount = Int(self.currentElement)

            case .CommentRSSLink:
                item.setCommentRSSLink1(self.currentElement)

            case .Author:
                item.author = self.currentElement

            case .Category:
                item.categories.append(self.currentElement)

            default:
                print("Unmatched case: \(element)")
            }
        }
        else
        {
            switch element {

            case .Title :
                feed.title = self.currentElement

            case .Link:
                feed.setLink1(self.currentElement)

            case .Language:
                feed.language = self.currentElement

            case .LastBuildDate:
                feed.setlastBuildDate(self.currentElement)

            case .Description:
                feed.feedDescription = self.currentElement

            case .Generator:
                feed.generator = self.currentElement

            case .Copyright:
                feed.copyright = self.currentElement

            default:
                print("Unmatched case: \(element)")

            }
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        self.currentElement += string
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
        if let closure = self.callbackClosure
        {
            closure(feed: nil, error: parseError)
        }
    }
    
}