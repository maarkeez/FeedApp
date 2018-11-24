//
//  FeedItem.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import UIKit
import FeedKit
import Kanna


class FeedItem {
    
    let imageSrc : String
    let imageUI : UIImage?
    let html : String
    let title : String
    let firstParagraph : String
    let idHash: String
    var readed: Bool
    
    init(_ feed: Feed) {
        html = FeedItem.parseHtml(feed.html)
        imageSrc = feed.imageSrc!
        imageUI = FeedItem.getUIImage(imageSrc)
        title = feed.title!
        firstParagraph = feed.firstParagraph!
        idHash = feed.id!
        readed = feed.readed
    }
    
    init(_ feed: RSSFeedItem) {
       
        html = FeedItem.parseHtml(feed.description)
        imageSrc = FeedItem.getFirstImageSrc(html)
        imageUI = FeedItem.getUIImage(imageSrc)
        title = feed.title ?? ""
        firstParagraph = FeedItem.getFirstParagraph(html)
        idHash = title.sha256() + "-" + html.sha256()
        readed = false
    }
    
    private static func parseHtml(_ input: String?) -> String{
       
        return input ?? ""
       
    }
    
    private static func getFirstImageSrc(_ html: String) -> String{
        if let doc = try? HTML(html: html, encoding: .utf8) {
           
            // Search for nodes by CSS
            for link in doc.css("img") {
                return link["src"] ?? ""
            }
        }
        return ""
    }
    
    private static func getFirstParagraph(_ html: String) -> String{
        if let doc = try? HTML(html: html, encoding: .utf8) {
            
            // Search for nodes by CSS
            for paragraph in doc.css("p") {
                if let paragraphText = paragraph.text , paragraphText != "" {
                    let  paragraphText = paragraphText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if paragraphText != "" {
                        return paragraphText
                    }
                }
            }
        }
        return ""
    }
    
    private static func getUIImage(_ image: String) -> UIImage? {
        let imageUrlOpt:URL? = URL(string: image)
        if let imageUrl = imageUrlOpt {
            let imageDataOpt:NSData? = NSData(contentsOf: imageUrl)
            if let imageData = imageDataOpt{
                let uiImage = UIImage(data: imageData as Data)
                return uiImage
            }
        }
        return nil
    }
}
