import UIKit

struct Tip {
    let selectedTipPercentage: Int
    let splitCount: Int
    let billAmount: Double

    var tipAmount: Double {
        return billAmount * Double(selectedTipPercentage) / 100
    }

    var totalAmount: Double {
        return billAmount + tipAmount
    }

    var amountPerPerson: Double {
        return totalAmount / Double(splitCount)
    }
}
