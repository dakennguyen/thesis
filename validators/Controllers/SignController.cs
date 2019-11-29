using System;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Mvc;

namespace validators.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SignController : ControllerBase
    {
        private const int keySize = 1024;

        [HttpGet("ministry")]
        public string Ministry([FromForm]string data)
        {
            string pkeyXml = "<RSAKeyValue><Modulus>rGPyzjgLuyBkdLCpJBfzAbng8zu2RB/eP35VgOlPxstvLSaXTzQUItk/hOe2xjHtikwIgbm8lHNEfnSB4FrkDrVlAeacfofEDID2FXE3VTwwXD5kf0K3L7Mhl5MuWfQ1VmMnNyffXTIRXRpJRaQOYuQqwKROKD9zP/P42aCqEJM=</Modulus><Exponent>AQAB</Exponent><P>3of7eAOLPsH+vzmYExoKSaqRZlmU71cK9oqFxL4y0WkmkcUgZIuuICIyc006DQEWlBbULZPP0z7yDNrFuw0AuQ==</P><Q>xlFrUIUjG/ZQXQcdmRrxienZ26eJ9t0DGfwpJcLKqNdKOBohUakXxMKjiCbKwnPJ53yO0Hhn0VqOqCcZtAK9qw==</Q><DP>yZdSndRIDqBbkQwx0gwjCb01Xw0EORYXXmT67dKH4uFpCWEVCUDoiz+viHiLgEBeHeXYbTmcafh5+l8uBVewMQ==</DP><DQ>tV26ld3cWPMvVZRvVhjU8nqB+abDvpcrAfWhL95v9m9Fef8zn3nTuecDJT3Myn6YFHLOLQsgbs6xjkiL8htblw==</DQ><InverseQ>GRViHdYoOSx8bIouUNf/kWWukfJVsJOWENDmCZWJqR4CidoCoashbn/xV5ij4fRIzOb2LhlbGoWAJB8zPipIhg==</InverseQ><D>k08tMm7OB29cqCI1xrP4Yac2xGJoE7qvrc4Evo2gMB2yuQBbF8FG26iNEML4elA7zYu/USsoLCp7gxuHx/GjIk7bHQgMoj175LFkE5xDr6cmaj0hpjwnidxrRxisW3OTg4cB6Iji3zuBK017qVSCgN9jSRFDE5kfLL9fSNiOKGE=</D></RSAKeyValue>";
            return this.Sign(data, pkeyXml);
        }

        [HttpGet("egov")]
        public string Egov([FromForm]string data)
        {
            string pkeyXml = "<RSAKeyValue><Modulus>0f2e/fr2McK9uH7PmYn1u5jRX+T+S8bmTnfdhKpc/2zQCnNyDJaQ0DCqfHBJWc5LJSdyushxnHK7VujZbyEpBK+ceMbftNOp/kqPblVefgfSTTSO6vC7R/4XbL4HA4DvaUFT+AnNcDKYQHT1vLbq9hjsNXsM7WCNHR6uMhT3kP8=</Modulus><Exponent>AQAB</Exponent><P>91QiAhcKnkJAJfrg0x//NSyy7qK/KzBPXQPDPj+CWU8rmCOfV4z9cot1CqfIWG3J8l1WrS1XV21707Dg/KByVQ==</P><Q>2Vpdw03k4FsWyh3E7x8z3o7jl8W1loa/E7KH4+qTZIis6kXC/Xf2DvkE5vlga7Hf87QBiYWWUZJYde//fZtSAw==</Q><DP>EJj2x0kgj0pG38WcPM7S45CiWV1WkuFlEgrkmVLNvoyPkmAhm1B82aj+K77itPx5JuiYnnqCd/2C58vg7VMfGQ==</DP><DQ>HtVb8cXODym83OVGN6nUgOECVlh8vyLUXmX4MxPm3t8osH8+/xgSduNKl72OuRhdrcO+aBTkUyQQmoJ2Wwo6ow==</DQ><InverseQ>Sy6OXSGmHEzlZoUdjfed3idIW3Q05UVC3qtojEL6rrBzv2GxkgZuu3jZhH5WZYbUyg0oKgQuQWZVTYcuc7px0w==</InverseQ><D>Fg0N/xm1dLBAf/lBD5x/I33+rpU7ZvWyBZdsuZuyPFhO2GobFdtRxar2nC6mZTnWhkZIM/kMhSM/LPcyrgrLZbPHRZi0LbiqpYBIbPOWG6baI8DR5SM2zFxeUMsvPgB4nwiNVb8wNnfZ3cS4wviCBLRqa0XcNZAu0/EbfvBCvFE=</D></RSAKeyValue>";
            return this.Sign(data, pkeyXml);

        }

        private string Sign(string data, string privateKey)
        {
            byte[] bytes = Encoding.ASCII.GetBytes(data);
            RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(keySize);
            rsa.FromXmlString(privateKey);
            var tmp = rsa.SignData(bytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            string hex = BitConverter.ToString(tmp).Replace("-", "").ToLower();
            return hex;

        }
    }
}
