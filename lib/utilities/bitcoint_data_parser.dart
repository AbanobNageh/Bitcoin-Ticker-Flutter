class BitcoinAPIParser {
  double getExchangeRate(decodedData) {
    return decodedData['rate'];
  }
}