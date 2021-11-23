﻿// Copyright (c) .NET Foundation. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Xunit;

namespace Microsoft.AspNet.WebHooks.Payloads
{
    public class PackageListedPayloadTests
    {
        [Fact]
        public void PackageListedPayload_Roundtrips()
        {
            // Arrange
            JObject data = EmbeddedResource.ReadAsJObject("Microsoft.AspNet.WebHooks.Messages.PackageListedMessage.json");
            PackageListedPayload expected = new PackageListedPayload
            {
                Action = "unlisted",
                PackageType = "NuGet",
                PackageIdentifier = "GoogleAnalyticsTracker.Simple",
                PackageVersion = "1.0.0-CI00002",
                FeedIdentifier = "sample-feed",
                FeedUrl = new Uri("https://www.myget.org/F/sample-feed/")
            };

            // Act
            PackageListedPayload actual = data["Payload"].ToObject<PackageListedPayload>();

            // Assert
            string expectedJson = JsonConvert.SerializeObject(expected);
            string actualJson = JsonConvert.SerializeObject(actual);
            Assert.Equal(expectedJson, actualJson);
        }
    }
}
