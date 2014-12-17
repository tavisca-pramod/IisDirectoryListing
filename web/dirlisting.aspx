<%@ Page Language="c#" Debug="true" %>
<%@ Import Namespace="Mvolo.DirectoryListing" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="NavigationEntityListing" %>

<script runat="server">
    void Page_Load()
    {
        String path = null;
        String parentPath = null;
        int count = 0;
        String sortBy = Request.QueryString["sortby"];

        //
        // Databind to the directory listing
        //
        DirectoryListingEntryCollection listing =
            Context.Items[DirectoryListingModule.DirectoryListingContextKey] as DirectoryListingEntryCollection;

        if (listing != null)
        {
            //
            // Handle sorting
            //
            if (!String.IsNullOrEmpty(sortBy))
            {
                if (sortBy.Equals("name"))
                {
                    listing.Sort(DirectoryListingEntry.CompareFileNames);
                }
                else if (sortBy.Equals("namerev"))
                {
                    listing.Sort(DirectoryListingEntry.CompareFileNamesReverse);
                }
                else if (sortBy.Equals("date"))
                {
                    listing.Sort(DirectoryListingEntry.CompareDatesModified);
                }
                else if (sortBy.Equals("daterev"))
                {
                    listing.Sort(DirectoryListingEntry.CompareDatesModifiedReverse);
                }
                if (sortBy.Equals("type"))
                {
                    listing.Sort(DirectoryListingEntryExtension.CompareFileTypes);
                }
                else if (sortBy.Equals("typerev"))
                {
                    listing.Sort(DirectoryListingEntryExtension.CompareFileTypesReverse);
                }
            }
            else
            {
                listing.Sort(DirectoryListingEntry.CompareFileNames);
            }

            DirectoryListing.DataSource = listing;
            DirectoryListing.DataBind();

            //
            //  Prepare the file counter label
            //
            FileCount.Text = listing.Count + " items";


            // Databind to the navigation list
            NavigationEntityCollection navigationList = new NavigationEntityCollection();

            //  Parepare the parent path label
            path = VirtualPathUtility.AppendTrailingSlash(Context.Request.Path);

            navigationList.Add(new NavigationEntity(HttpRuntime.AppDomainAppVirtualPath.Replace('/', ' ').Trim(),
                                                    HttpRuntime.AppDomainAppVirtualPath));

            String tempPath = path.Remove(path.Length - 1);

            NavigationEntityCollection tempNavigationList = new NavigationEntityCollection();

            // To generate navigation list items
            while (!(tempPath.Equals("/") || tempPath.Equals(HttpRuntime.AppDomainAppVirtualPath)))
            {
                string[] displayPath = tempPath.Split('/');

                tempNavigationList.Add(new NavigationEntity(displayPath[displayPath.Length - 1], tempPath));
                parentPath = VirtualPathUtility.Combine(tempPath, ".");

                tempPath = parentPath;
            }

            tempNavigationList.Reverse();
            navigationList.AddRange(tempNavigationList);
            NavigationListView.DataSource = navigationList;
            NavigationListView.DataBind();
        }
    }

    String GetFileSizeString(FileSystemInfo info)
    {
        if (info is FileInfo)
        {
            return String.Format("{0}K", ((int)(((FileInfo)info).Length * 10 / (double)1024) / (double)10));
        }
        return String.Empty;
    }

    String GetFileDateModifiedString(FileSystemInfo info)
    {
        if (info is FileInfo)
        {
            return info.LastWriteTime.ToString("MMM dd") + " at " + info.LastWriteTime.ToShortTimeString();
        }
        return String.Empty;
    }

    String GetFileTypeString(FileSystemInfo info)
    {
        if (info is FileInfo)
        {
            return info.Extension;
        }
        return String.Empty;
    }

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Directory contents of <%= Context.Request.Path %></title>
    <link rel="stylesheet" type="text/css" href="/web/content/default.css"/>
     <script type="text/javascript" src="/web/content/sortable.js"></script>
</head>
<body>
    <form id="Form1" runat="server">
        <div class="wrapper">
            <!--  **************** header Div ********************** -->
            <div class="clearfix">

                <!--  ******** Breadcurm ********** -->
                <div class="breadcrm">

                    <asp:Repeater ID="NavigationListView" runat="server">
                        <ItemTemplate>
                            <li>
                                <a href="<%#((NavigationEntity)Container.DataItem).PathValue%>"><%#((NavigationEntity)Container.DataItem).DisplayValue%></a>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>

                </div>
                <!--  ******** Breadcurm End ********** -->

                <!--  ******** item Count ********** -->
                <div class="item-count">
                    <asp:Label runat="Server" ID="FileCount" />
                </div>
                <!--  ******** item Count End ********** -->

            </div>
            <!--  **************** header Div End ********************** -->

            <div class="data-table clearfix">
                <asp:DataList ID="DirectoryListing" runat="server" CssClass="sortable">
                    <HeaderTemplate>
                        <th style="width: 30%">name<span id="sorttable_sortfwdind"><i class="sort asc"></i></span></th>
                        <th style="width: 13%">type</th>
                       <th style="width: 22%">last updated</th>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <td>
                            <img alt="icon" width="15"
                                src="<%=HttpRuntime.AppDomainAppVirtualPath %>/geticon.axd?file=<%# Path.GetExtension(((DirectoryListingEntry)Container.DataItem).Path) %>" />
                            <a href="<%# ((DirectoryListingEntry)Container.DataItem).VirtualPath  %>">
                                <i class="folder"></i><%# ((DirectoryListingEntry)Container.DataItem).Filename %>
                            </a>
                        </td>
                        <td>
                            <%# GetFileTypeString(((DirectoryListingEntry)Container.DataItem).FileSystemInfo) %>    
                        </td>
                        <td>
                            <%# GetFileDateModifiedString(((DirectoryListingEntry)Container.DataItem).FileSystemInfo) %>    
                        </td>

                    </ItemTemplate>
                </asp:DataList>

            </div>

        </div>
    </form>
</body>
</html>
