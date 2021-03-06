//
//  RegexParser.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import Foundation

struct RegexParser {
    
    static let urlPattern = "(^|[\\s.:;?\\-\\]<\\(])" +
        "((https?://|www.|pic.)[-\\w;/?:@&=+$\\|\\_.!~*\\|'()\\[\\]%#,☺]+[\\w/#](\\(\\))?)" +
    "(?=$|[\\s',\\|\\(\\).:;?\\-\\[\\]>\\)])"
    
    static let hashtagRegex = try? NSRegularExpression(pattern: "(?:^|\\s|$)#[a-z0-9_]*", options: [.CaseInsensitive])
    static let mentionRegex = try? NSRegularExpression(pattern: "(?:^|\\s|$|[.])@[a-z0-9_]*", options: [.CaseInsensitive])
    static let urlDetector = try? NSRegularExpression(pattern: urlPattern, options: [.CaseInsensitive])
    static let slackUserRegex = try? NSRegularExpression(pattern: "(?:^|\\s|$)<@[a-z0-9_]*|[a-z0-9_]*>", options: [.CaseInsensitive])
//    static let slackUserRegex = try? NSRegularExpression(pattern: "^.*<@(.*\|.*)>.*$", options: [.CaseInsensitive])
    
    static func getSlackMentions(fromText text: String, range: NSRange) -> [NSTextCheckingResult]{
        guard let slackUserRegex = slackUserRegex else { return [] }
        return slackUserRegex.matchesInString(text, options: [], range: range)
    }
    static func getMentions(fromText text: String, range: NSRange) -> [NSTextCheckingResult] {
        guard let mentionRegex = mentionRegex else { return [] }
        return mentionRegex.matchesInString(text, options: [], range: range)
    }
    
    static func getHashtags(fromText text: String, range: NSRange) -> [NSTextCheckingResult] {
        guard let hashtagRegex = hashtagRegex else { return [] }
        return hashtagRegex.matchesInString(text, options: [], range: range)
    }
    
    static func getURLs(fromText text: String, range: NSRange) -> [NSTextCheckingResult] {
        guard let urlDetector = urlDetector else { return [] }
        return urlDetector.matchesInString(text, options: [], range: range)
    }
    
}