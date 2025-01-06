//module.exports
//require

const firstModule = require("./first-module");

console.log(firstModule.add(10, 20));

try {
  console.log("trying to divide by zero");
  let result = firstModule.divide(0, 10);
  console.log(result, "result");
} catch (error) {
  console.log("Caught an error", error.message);
}
