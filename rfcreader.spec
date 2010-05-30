#
# vim:filetype=spec:nowrap:
#

%define	ver		0.0
%define	rel		1

#Vendor:		Henning Hucke
#Packager:	Henning Hucke <h_hucke@aeon.icebear.org>
Name:		rfcreader
Version:	%{ver}
Release:	%{rel}
License:	GPL
Summary:	Script to transparently retrieve RFCs for reading.
Group:		Unknown
Source:		%{name}-%{ver}-%{rel}.tgz
#URL:		<information resource>
BuildRoot:	%{_tmppath}/%{name}-%{ver}-%{rel}-root
#Patch:		<optional patches>
#Prefix:	/usr
Distribution:	Private
#Provides:	
%description
This script first searches locally for specified RFCs and the on configurable
sources in the internet. Found RFCs are stored in a local cache if found
externally. After retrieval the pager in started for reading the specified
RFCs.

%files
#%doc README
%attr(0555,root,root) %{_bindir}/%{name}
%doc %{_mandir}/man?/%{name}*
%doc %{_mandir}/de*/man?/%{name}*
%dir %{_localstatedir}/cache/rfcs

%prep
%setup -q -n %{name}
#%patch -p1

%build
%configure --version=%{ver}.%{rel}

%install
%makeinstall
%_fixowner %{?buildroot:%{buildroot}}
%_fixgroup %{?buildroot:%{buildroot}}

%clean
%__rm -rf %{?buildroot:%{buildroot}}

%changelog
* Fri Aug 15 2008 - Henning Hucke <h_hucke+rfc@aeon.icebear.org>

- Initial Version of this package.
