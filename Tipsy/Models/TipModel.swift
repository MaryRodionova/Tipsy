struct TipModel {
    var tip: Tip?

    func validateBillAmount(_ billText: String?) -> Double? {
        guard let billText = billText,
              !billText.isEmpty,
              let billAmount = Double(billText),
              billAmount > 0 else {
            return nil
        }
        return billAmount
    }

    mutating func createTip(billText: String?, tipPercentage: Int, splitCount: Int) -> Tip? {
        guard let billAmount = validateBillAmount(billText) else {
            return nil
        }
        
        let newTip = Tip(
            selectedTipPercentage: tipPercentage,
            splitCount: splitCount,
            billAmount: billAmount
        )

        self.tip = newTip
        return newTip
    }
}
