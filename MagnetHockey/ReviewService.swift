//
//  ReviewService.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 5/1/20.
//  Copyright © 2020 Wysong, Trevor. All rights reserved.


import Foundation
import StoreKit

class ReviewService
{
    private init() {}
    static let shared = ReviewService()

    private let defaults = UserDefaults.standard
    private let app = UIApplication.shared

    private var lastRequest: Date?
    {
        get
        {
            return defaults.value(forKey: "ReviewService.lastRequest") as? Date
        }
        set
        {
            defaults.set(newValue, forKey: "ReviewService.lastRequest")
        }
    }

    private var oneWeekAgo: Date
    {
        return Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    }

    public var shouldRequestReview: Bool
    {
        if ((UserDefaults.standard.integer(forKey: "NumberReviews") <= 2) && (UserDefaults.standard.integer(forKey: "MagnetHockeyGames") >= 5) && (UserDefaults.standard.string(forKey: "EnjoyedApp") != "No"))
        {
            if lastRequest == nil
            {
                return true
            }
            else if let lastRequest = self.lastRequest, lastRequest < oneWeekAgo
            {
                return true
            }
        }
        return false
    }

    func requestReview(isWrittenReview: Bool = false)
    {
        guard shouldRequestReview else { return }
        if isWrittenReview
        {
            let appStoreUrl = URL(string: "https://itunes.apple.com/app/id1510839829?action=write-review")!
            app.open(appStoreUrl)
        }
        if !isWrittenReview
        {
            SKStoreReviewController.requestReview()
        }
        lastRequest = Date()
    }
}

