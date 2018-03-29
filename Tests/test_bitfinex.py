import pytest
import requests
import time


class TestBitfinex:

    @classmethod
    def setup_class(cls):
        cls.url_bitfinex = 'https://api.bitfinex.com/'

    @classmethod
    def setup_method(cls):
        cls.session = requests.session()

    @pytest.mark.timeout(10)
    def test_btcusd_price(self):
        """Test verify that current btcusd price is present"""
        url = self.url_bitfinex + 'v1/pubticker/btcusd'
        response = self.session.get(url)
        assert(response.json()['bid'])

    @pytest.mark.timeout(10)
    def test_symbols_list_len(self):
        """Test verify that request on 'v1/symbols' returns nonempty list"""
        url = self.url_bitfinex + 'v1/symbols'
        response = self.session.get(url)
        assert(len(response.json()) > 0)

    @pytest.mark.timeout(10)
    def test_symbols_higth_rate(self):
        """Test verify that after more than 5 requests per minute
        on 'v1/symbols' returns status code 429
        """
        url = self.url_bitfinex + 'v1/symbols'
        for i in range(7):
            self.session.get(url)
        response = self.session.get(url)
        assert(response.status_code == 429)

    @pytest.mark.timeout(75)
    def test_symbols_low_rate(self):
        """Test verify that after less than 5 requests per minute
                on 'v1/symbols' returns status code 200
        """
        time.sleep(65)
        url = self.url_bitfinex + 'v1/symbols'
        response = self.session.get(url)
        for i in range(5):
            response = self.session.get(url)
            assert(response.status_code == 200)