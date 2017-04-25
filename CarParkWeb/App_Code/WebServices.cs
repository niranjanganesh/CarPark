using System;
using System.Configuration;
using System.Net;

namespace Argonaut
{
    namespace Car_Park
    {
        public class Car_Park : CarParkWeb.Car_park.Car_Park
        {
            public Car_Park()
            {
                base.Credentials = WebServices.GetCredentials();
            }
        }
    }
    class WebServices
    {
        public static NetworkCredential GetCredentials()
        {
            WebServicesAuthentication authentication = (WebServicesAuthentication)ConfigurationManager.GetSection("webServicesAuthentication");

            if (authentication != null && authentication.Required)
                return new NetworkCredential(authentication.Credentials.UserName, authentication.Credentials.Password, authentication.Credentials.Domain);
            else
                return null;
        }
    }

    class WebServicesAuthentication : ConfigurationSection
    {
        [ConfigurationProperty("required", DefaultValue = false, IsRequired = true)]
        public bool Required
        {
            get { return (bool)this["required"]; }
        }

        [ConfigurationProperty("credentials", IsRequired = true)]
        public Credentials Credentials
        {
            get { return this["credentials"] as Credentials; }
        }
    }


    class Credentials : ConfigurationElement
    {
        [ConfigurationProperty("userName", IsRequired = true)]
        public string UserName
        {
            get { return (string)this["userName"]; }
        }

        [ConfigurationProperty("password", IsRequired = true)]
        public string Password
        {
            get { return (string)this["password"]; }
        }

        [ConfigurationProperty("domain", IsRequired = true)]
        public string Domain
        {
            get { return (string)this["domain"]; }
        }
    }
}