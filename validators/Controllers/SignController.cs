using System;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Mvc;

namespace validators.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SignController : ControllerBase
    {
        [HttpGet]
        public string Get(string value)
        {
            int keySize = 512;
            string pkeyXml = "<RSAKeyValue><Modulus>tp/UkxAHFt/dihOf3AMIO46SSM7pfsL6l7l+F+vOWFuECHmw7Cv4Loi8M3egwxFFXmYnleRjfz1wmmyYehjIOw==</Modulus><Exponent>AQAB</Exponent><P>6GbdN4sDxI4Mp3GGj4kVoK1O9w1KGRHRQ4aMh+AjqSM=</P><Q>ySsIYQY8YTDpS7tcONRYfu5pgA6KVasPbYBHB21lMgk=</Q><DP>dgAkupr/IsHtcueVpzO3o4nb2l0JDomZc2vR1vvbn3k=</DP><DQ>Q8NXIzeyhxquu2/1dL8ywC8XIqfDOXBR1hTr2DilaeE=</DQ><InverseQ>BaInqudZi7mah+WMNj5tDWpbIQci9kuv4Qt/X7kCvZ8=</InverseQ><D>CRNuZBSi1Y8wmmEZS7zW1ubh/D5UOlmETLAKRTQR4DAulngLsdEQdz0LQol5K6vs/3zUTWynlFU5rCMp4o4QkQ==</D></RSAKeyValue>";

            byte[] bytes = Encoding.ASCII.GetBytes(value);

            RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(keySize);
            rsa.FromXmlString(pkeyXml);
            var tmp = rsa.SignData(bytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            string hex = BitConverter.ToString(tmp).Replace("-", "").ToLower();
            return hex;
        }
    }
}
