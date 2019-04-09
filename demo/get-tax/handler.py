import sys, json

# EXPECTS {"subtotal":INT}
def handle(req):
  subtotal = json.loads(req)["subtotal"]

  tax = subtotal * 0.047

  print({ "tax": tax })
