﻿// Copyright (c) .NET Foundation. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.ObjectModel;
using Newtonsoft.Json;

namespace Microsoft.AspNet.WebHooks
{
    /// <summary>
    /// An <see cref="IWebHookHandler"/> can post a response to a Slack Slash request by updating the
    /// <see cref="System.Net.Http.HttpResponseMessage"/> on the <see cref="WebHookHandlerContext"/> with a response
    /// containing a <see cref="SlackSlashResponse"/>. Please see <c>https://api.slack.com/docs/attachments#message_formatting</c>
    /// for additional details.
    /// </summary>
    public class SlackSlashResponse
    {
        private readonly Collection<SlackAttachment> _attachments = new Collection<SlackAttachment>();

        private string _text;

        /// <summary>
        /// Initializes a new instance of the <see cref="SlackSlashResponse"/> class with the given <paramref name="text"/>.
        /// </summary>
        /// <param name="text">The Slack Slash command response text. The text may contain Markdown-style formatting
        /// as described in <c>https://api.slack.com/docs/formatting</c>. The contents will automatically be collapsed
        /// if it contains more than 700 characters or more than 5 line breaks. In this case it will be displayed with
        /// a <c>"Show more..."</c> link to the contents.
        /// </param>
        public SlackSlashResponse(string text)
            : this(text, new SlackAttachment[0])
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="SlackSlashResponse"/> class with the given <paramref name="text"/> and
        /// one or more <see cref="SlackAttachment"/> instances for additional response information. Please see
        /// <see cref="SlackAttachment"/> for all the options available.
        /// </summary>
        /// <param name="text">The Slack Slash command response text. The text may contain Markdown-style formatting
        /// as described in <c>https://api.slack.com/docs/formatting</c>. The contents will automatically be collapsed
        /// if it contains more than 700 characters or more than 5 line breaks. In this case it will be displayed with
        /// a <c>"Show more..."</c> link to the contents.
        /// </param>
        /// <param name="attachments">One or more <see cref="SlackAttachment"/> instances providing additional response information.
        /// Please see <see cref="SlackAttachment"/> for all the options available.</param>
        public SlackSlashResponse(string text, params SlackAttachment[] attachments)
        {
            if (text == null)
            {
                throw new ArgumentNullException(nameof(text));
            }
            if (attachments == null)
            {
                throw new ArgumentNullException(nameof(attachments));
            }

            _text = text;
            foreach (var att in attachments)
            {
                _attachments.Add(att);
            }
        }

        /// <summary>
        /// Default constructor for serialization purposes
        /// </summary>
        internal SlackSlashResponse()
        {
        }

        /// <summary>
        /// Gets or sets the Slack Slash Response text.
        /// </summary>
        [JsonProperty("text")]
        public string Text
        {
            get
            {
                return _text;
            }
            set
            {
                if (value == null)
                {
                    throw new ArgumentNullException(nameof(value));
                }
                _text = value;
            }
        }

        /// <summary>
        /// Gets or sets the Slack Slash Response type. This value must be either <c>in_channel</c> or <c>ephemeral</c>.
        /// If <c>in_channel</c> then both the response message and the initial message typed by the user will be shared in the channel.
        /// If <c>ephemeral</c> (default) then the response message will be visible only to the user that issued the command.
        /// </summary>
        [JsonProperty("response_type")]
        public string ResponseType { get; set; }

        /// <summary>
        /// Gets a set of <see cref="SlackAttachment"/> instances that will comprise the Slack Slash response.
        /// </summary>
        [JsonProperty("attachments")]
        public Collection<SlackAttachment> Attachments
        {
            get
            {
                return _attachments;
            }
        }
    }
}
