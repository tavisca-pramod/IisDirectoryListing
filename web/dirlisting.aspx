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
            string fileExtension = info.Extension.Remove(0,1);
            
            switch (fileExtension){
                case "svgz": fileExtension = "SVG Image"; break;
				case "png": fileExtension = "PNG Image";break; 
				case "jpg": fileExtension = "JPEG Image"; break;
				case "jpeg": fileExtension = "JPEG Image"; break;
				case "svg": fileExtension = "SVG Image"; break;
				case "gif": fileExtension = "GIF Image"; break;
				case "ico": fileExtension = "Windows Icon"; break;

				case "txt": fileExtension = "Text File"; break;
				case "log": fileExtension = "Log File"; break;
				case "htm": fileExtension = "HTML File"; break;
				case "html": fileExtension = "HTML File"; break;
				case "xhtml": fileExtension = "HTML File"; break;
				case "shtml": fileExtension = "HTML File"; break;
				
                case "aspx": fileExtension="ASP Script"; break;
				case "asp": fileExtension="ASP Script"; break;
				
                case "js": fileExtension = "Javascript File"; break;
				case "css": fileExtension = "Stylesheet"; break;

				case "pdf": fileExtension = "PDF Document"; break;
				case "xls": fileExtension = "Spreadsheet"; break;
				case "xlsx": fileExtension = "Spreadsheet"; break;
				case "doc": fileExtension = "Microsoft Word Document"; break;
				case "docx": fileExtension = "Microsoft Word Document"; break;

				case "zip": fileExtension = "ZIP Archive"; break;
				case "htaccess": fileExtension = "Apache Config File"; break;
				case "exe": fileExtension = "Windows Executable"; break;


                case "m4v":
                case "ogg":
                case "ogv":
                case "MOV":
                case "webm": fileExtension = "Video File"; break;

                case "oga":
                case "spx": fileExtension = "Audio File"; break;

                case "eot":
                case "otf":
                case "ttf":
                case "woff": fileExtension = "Font File"; break;


				default: if(fileExtension!=""){fileExtension =fileExtension.ToUpper()+" File";} else{fileExtension = "Unknown";} break;
			}
            return fileExtension;
        }
        return "Folder";
    }

    String GetTarget(FileSystemInfo info)
    {
        if (info is FileInfo)
        {
            string fileExtension = info.Extension.Remove(0, 1);
            

            switch (fileExtension)
            {
                case "png": 
                case "jpg": 
                case "jpeg":
                case "svg":
                case "svgz": 
                case "gif": 
                case "ico": 

                case "txt": 
                case "log": 
                case "htm": 
                case "html":
                case "xhtml": 
                case "shtml": 

                case "aspx": 
                case "asp": 

                case "js": 
                case "css":

                case "pdf":
                case "xls":
                case "xlsx":
                case "doc": 
                case "docx":


                case "m4v":
                case "ogg":
                case "ogv":
                case "webm":
                case "mov":

                case "oga":
                case "spx": 

                case "eot":
                case "otf":
                case "woff":
                case "ttf":

                case "zip": 
                case "htaccess":
                case "exe": return "_blank";
                default: return "_self";
            }
        }

        return "_self";        
    }


    String GetImageFont(FileSystemInfo info)
    {
        if (info is FileInfo)
        {
            string fileExtension = info.Extension.Remove(0, 1);

            switch (fileExtension)
            {
                case "png":
                case "jpg":
                case "jpeg":
                case "svg":
                case "svgz":
                case "gif":
                case "tiff":
                case "bmp":
                case "ico": return "photo-picture";

                case "htm":
                case "html":
                case "xhtml":
                case "shtml": return "html";

                case "aspx":
                case "asp": return "aspx-1";

                case "js": return "js";
                case "css": return "css";

                case "txt":
                case "log":
                case "pdf":
                case "xls":
                case "xlsx":
                case "ppt":
                case "pptx":
                case "doc":
                case "docx": return "file-2";

                case "avi":
                case "mp4":
                case "m4v":
                case "ogg":
                case "ogv":
                case "mov":
                case "webm": return "video";

                case "oga":
                case "mp3":
                case "wav":
                case "flac":
                case "spx": return "music";

                case "eot":
                case "otf":
                case "ttf":
                case "woff": return "font";

                case "zip":
                case "htaccess":
                case "exe":

                default: return "file-2";
            }
        }

        return "folder";

    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Directory contents of <%= Context.Request.Path %></title>
    <link rel="stylesheet" type="text/css" href="/content/default.css"/>
    <link rel="stylesheet" type="text/css" href="/content/styles.css"/>
     <script type="text/javascript" src="/content/sortable.js"></script>
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
                            <i class="i-<%# GetImageFont(((DirectoryListingEntry)Container.DataItem).FileSystemInfo) %>"></i>
                            <a href="<%# ((DirectoryListingEntry)Container.DataItem).VirtualPath  %>" target="<%# GetTarget(((DirectoryListingEntry)Container.DataItem).FileSystemInfo) %>">
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
