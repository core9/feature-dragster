import 'lib/dragdrop.dart';
import "package:dice/dice.dart";

import 'dart:html';

List<Element> _columnsElements = document.querySelectorAll('#columns');

void main() {
  DragDrop dragdrop = new DragDropImpl();
  dragdrop.start();

  /*

  var injector = new Injector(new Dragster());
  var billingService = injector.getInstance(BillingService);
  var creditCard = new CreditCard("VISA");
  var order = new Order("Dart: Up and Running");
  Receipt receipt = billingService.chargeOrder(order, creditCard);
  Order myOrder = receipt.getOrder();
  print(myOrder.item);
  * 
  */

}


class Dragster extends Module {
  configure() {
    // bind CreditCardProcessor to a singleton
    register(CreditProcessor).toInstance(new CreditProcessorImpl());
    // bind BillingService to a type
    register(BillingService).toType(BillingServiceImpl);
  }
}


class BillingServiceImpl implements BillingService {
  @inject
  CreditProcessor _processor;

  Receipt chargeOrder(Order order, CreditCard creditCard) {
    if (!(_processor.validate(creditCard))) {
      throw new ArgumentError("payment method not accepted");
    }
    // :
    print("charge order for ${order.item}");
    return new Receipt(order);
  }
}

class CreditProcessorImpl implements CreditProcessor {
  bool validate(CreditCard card) => card.type.toUpperCase() == "VISA";
}

abstract class BillingService {
  Receipt chargeOrder(Order order, CreditCard creditCard);
}

abstract class CreditProcessor {
  bool validate(CreditCard creditCard);
}

class CreditCard {
  CreditCard(this.type);
  final String type;
}

class Order {
  Order(this.item);
  final String item;
}

class Receipt {
  Order _order;
  Receipt(Order order) {
    _order = order;
  }

  Order getOrder() {
    return _order;
  }
}
