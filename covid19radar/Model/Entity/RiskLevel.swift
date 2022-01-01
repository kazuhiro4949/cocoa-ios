//
//  RiskLevel.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//
import Foundation

public enum RiskLevel: Int, Codable
{
    case invalid
    case lowest
    case low
    case lowMedium
    case medium
    case mediumHigh
    case high
    case veryHigh
    case highest
}
