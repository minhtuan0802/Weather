//
//  StringExtensions.swift //  BabyPhoto
//
//  Created by Thanh Vu on 6/24/20.
//  Copyright © 2020 Solar. All rights reserved.
//

import Foundation

public extension String {
  subscript(value: Int) -> Character {
    self[index(at: value)]
  }
}

public extension String {
    func deleteCharactersInRange(range: NSRange) -> String{
        let mutableSelf = NSMutableString(string: self)
        mutableSelf.deleteCharacters(in: range)
        return String(mutableSelf)
    }
}
public extension String {
  subscript(value: NSRange) -> String {
    return String(self[value.lowerBound..<value.upperBound])
  }
}

public extension String {
  subscript(value: CountableClosedRange<Int>) -> Substring {
    self[index(at: value.lowerBound)...index(at: value.upperBound)]
  }

  subscript(value: CountableRange<Int>) -> Substring {
    self[index(at: value.lowerBound)..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeUpTo<Int>) -> Substring {
    self[..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeThrough<Int>) -> Substring {
    self[...index(at: value.upperBound)]
  }

  subscript(value: PartialRangeFrom<Int>) -> Substring {
    self[index(at: value.lowerBound)...]
  }
}

private extension String {
  func index(at offset: Int) -> String.Index {
    index(startIndex, offsetBy: offset)
  }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
