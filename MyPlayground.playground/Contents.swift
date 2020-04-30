import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double
    init(name: String, amount: Int, price: Double) {
        self.name = name
        self.amount = amount
        self.price = price
    }
}

enum VendingMachineError: Error {
    case productNotFound
    case productUnavailable
    case insuficientFunds
    case productStuck
}

extension VendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "n tem o produto"
        case .productUnavailable:
            return "acabou isso ai"
        case .insuficientFunds:
            return "seu pobre"
        case .productStuck:
            return "seu produto ficou preso"
        }
    }
}

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
    }
    
    func getProduct(named name: String, with money: Double) throws {
        self.money += money
        
        let produtoOptional = self.estoque.first { (produto) -> Bool in
            return produto.name == name
        }
        
        guard let produto = produtoOptional else {
            throw VendingMachineError.productNotFound
        }
        
        guard produto.amount > 0 else {
            throw VendingMachineError.productUnavailable
        }

        guard produto.price <= money else {
            throw VendingMachineError.insuficientFunds
        }

        self.money -= produto.price
        produto.amount -= 1
        
        if Int.random(in: 0...100) < 10 {
            throw VendingMachineError.productStuck
        }
    }
    
    func getTroco() -> Double {
        var money = self.money
        self.money = 0.0
        
        return money
    }
}

let vendingMachine = VendingMachine(products: [
    VendingMachineProduct(name: "Carregador de iPhone", amount: 5, price: 150.00),
    VendingMachineProduct(name: "Cebolitos", amount: 2, price: 7.00),
    VendingMachineProduct(name: "Umbrella", amount: 5, price: 125.00),
    VendingMachineProduct(name: "Trator", amount: 1, price: 75000.00)

    ])

do {
    try vendingMachine.getProduct(named: "Umbrela", with: 130.00)
} catch {
    print(error.localizedDescription)
}

