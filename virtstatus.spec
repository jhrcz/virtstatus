Name: 		virtstatus
Version: 	0.4
Release:	0%{?dist}
Summary:	Run virtstatus
BuildArch: 	noarch

Group:		ETN
License:	GPL
#URL:		http://upstream-url.org/path
Source0: 	virtstatus-%{version}.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

BuildRequires:	sed
Requires:	cronic

%description
no description

%prep
%setup -q

%build

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%config(noreplace) %attr(644,root,root) /etc/virtstatus/*
%config(noreplace) %attr(644,root,root) /etc/cron.d/virtstatus
/usr/bin/virtstatus-html
%doc CHANGELOG.txt

%post
ln -sf /etc/virtstatus/apache2.conf.inc /etc/httpd/conf.d/virtstatus.conf

%changelog
* Tue Feb 14 2012 <jahor@jhr.cz> 0.4
- pro kvm zobrazeni do ktereho bridge virtual zapojen

* Fri Dec 16 2011 <jahor@jhr.cz> 0.3
- repackaging

