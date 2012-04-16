describe("calculator", function() {

  it("evaluate the expression as true", function() {
     expect(Carrie.Calc.validateExpression('1+2')).toEqual(true);
     expect(Carrie.Calc.validateExpression('1^2')).toEqual(true);
  });

  it("evaluate the expression as false", function() {
    expect(Carrie.Calc.validateExpression('1+2+')).toEqual(false);
  });

});
