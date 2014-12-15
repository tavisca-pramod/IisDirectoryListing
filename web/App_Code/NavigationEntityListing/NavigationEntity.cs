using System;
using System.Collections.Generic;
using System.Web;

namespace NavigationEntityListing
{
    /// <summary>
    /// Used to hold Navigation unit details to be used in as bredcrum
    /// </summary>
    public class NavigationEntity
    {
        private string displayValue;

        private string pathValue;

        public string DisplayValue
        {
            get { return displayValue; }
        }

        public string PathValue
        {
            get { return pathValue; }
        }

        public NavigationEntity(string DisplayValue, string PathValue)
        {
            this.displayValue = DisplayValue;
            this.pathValue = PathValue;
        }
    }

    /// <summary>
    ///  Custom Navigation module for the site
    /// </summary>
    public class NavifationEntityModule : IHttpModule
    {
        public const string NavifationEntityContextKey = "NavigationEntityListing";

        #region Implementation of IHttpModule

        /// <summary>
        /// Initializes a module and prepares it to handle requests.
        /// </summary>
        /// <param name="context">An <see cref="T:System.Web.HttpApplication"/> that provides access to the methods, properties, and events common to all application objects within an ASP.NET application </param>
        public void Init(HttpApplication context)
        {
            context.BeginRequest += context_BeginRequest;
            context.PreRequestHandlerExecute += context_PreRequestHandlerExecute;
            context.EndRequest += context_EndRequest;
            context.AuthorizeRequest += context_AuthorizeRequest;
        }

        private void context_AuthorizeRequest(object sender, EventArgs e)
        {
            //We change uri for invoking correct handler
            HttpContext context = ((HttpApplication) sender).Context;

            if (context.Request.RawUrl.Contains(".bspx"))
            {
                string url = context.Request.RawUrl.Replace(".bspx", ".aspx");
                context.RewritePath(url);
            }
        }

        private void context_PreRequestHandlerExecute(object sender, EventArgs e)
        {
            //We set back the original url on browser
            HttpContext context = ((HttpApplication) sender).Context;

            if (context.Items["originalUrl"] != null)
            {
                context.RewritePath((string) context.Items["originalUrl"]);
            }
        }

        private void context_EndRequest(object sender, EventArgs e)
        {
            //We processed the request
        }

        private void context_BeginRequest(object sender, EventArgs e)
        {
            //We received a request, so we save the original URL here
            HttpContext context = ((HttpApplication) sender).Context;

            if (context.Request.RawUrl.Contains(".bspx"))
            {
                context.Items["originalUrl"] = context.Request.RawUrl;
            }
        }

        /// <summary>
        /// Disposes of the resources (other than memory) used by the module that implements <see cref="T:System.Web.IHttpModule"/>.
        /// </summary>
        public void Dispose()
        {
            throw new NotImplementedException();
        }

        #endregion
    }

    /// <summary>
    /// Collection of NavigationEntity to be used for dynamic list population on bredcrum
    /// </summary>
    public class NavigationEntityCollection : List<NavigationEntity>
    {
        public NavigationEntityCollection(int capacity) : base(capacity)
        {
        }

        public NavigationEntityCollection(IEnumerable<NavigationEntity> collection) : base(collection)
        {
        }

        public NavigationEntityCollection()
        {
        }
    }
}