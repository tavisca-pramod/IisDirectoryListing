using System;
using System.Collections.Generic;
using Mvolo.DirectoryListing;

/// <summary>
/// Summary description for DirectoryListingEntryExtension
/// </summary>
public class DirectoryListingEntryExtension : DirectoryListingEntry
{
    public DirectoryListingEntryExtension(string virtualPath, string path, bool isDirectory)
        : base(virtualPath,path,isDirectory)
	{
		
	}

    public static int CompareFileTypes(DirectoryListingEntry entry1, DirectoryListingEntry entry2)
    {
        return String.Compare(entry1.Extension, entry2.Extension, StringComparison.Ordinal);
    }

    public static int CompareFileTypesReverse(DirectoryListingEntry entry1, DirectoryListingEntry entry2)
    {
        return System.String.Compare(entry2.Extension, entry1.Extension, StringComparison.Ordinal);
    }
}