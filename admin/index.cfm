<cfif NOT structKeyExists(session, 'authenticated') OR session.authenticated neq true>
    <cfheader statusCode="302" name="Location" value="login.cfm">
    <cfabort>
</cfif>

<cfparam name="url.view" default="dashboard">

<cfsilent>
    <cfset currentView = lcase(trim(url.view))>
    <cfset stats = [
        {label="New Quote Requests", value="12", change="+8%", icon="bi-file-earmark-text", tone="primary"},
        {label="Pending Quotes", value="7", change="-2%", icon="bi-clock-history", tone="warning"},
        {label="New Contact Inquiries", value="5", change="+3%", icon="bi-chat-dots", tone="info"},
        {label="Gallery Photos", value="28", change="+10%", icon="bi-images", tone="success"}
    ]>

    <cfset recentQuotes = [
        {date="2026-08-27", customer="Maria Santos", location="Cavite", ladderType="Folding Ladder", service="Supply & Install", status="New"},
        {date="2026-08-26", customer="John Reyes", location="Alabang", ladderType="Accordion Ladder", service="Supply & Install", status="Contacted"},
        {date="2026-08-25", customer="Carlo Mendoza", location="Las Piñas", ladderType="Folding Ladder", service="Supply Only", status="Quoted"},
        {date="2026-08-24", customer="Anne Cruz", location="Taguig", ladderType="Folding Ladder", service="Supply & Install", status="Scheduled"},
        {date="2026-08-23", customer="Mark Lim", location="Parañaque", ladderType="Accordion Ladder", service="Supply & Install", status="Completed"}
    ]>

    <cfset quoteList = [
        {id="ALPH-1001", date="2026-08-27", customer="Maria Santos", mobile="0917-123-4567", email="maria.santos@email.com", location="Cavite", ladderType="Folding Ladder", service="Supply & Install", status="New"},
        {id="ALPH-1002", date="2026-08-26", customer="John Reyes", mobile="0918-765-4321", email="john.r@email.com", location="Alabang", ladderType="Accordion Ladder", service="Supply & Install", status="Contacted"},
        {id="ALPH-1003", date="2026-08-25", customer="Carlo Mendoza", mobile="0922-334-4556", email="carlo.m@email.com", location="Las Piñas", ladderType="Folding Ladder", service="Supply Only", status="Quoted"},
        {id="ALPH-1004", date="2026-08-24", customer="Anne Cruz", mobile="0933-889-0012", email="anne.c@email.com", location="Taguig", ladderType="Folding Ladder", service="Supply & Install", status="Scheduled"},
        {id="ALPH-1005", date="2026-08-23", customer="Mark Lim", mobile="0906-999-2244", email="mark.l@email.com", location="Parañaque", ladderType="Accordion Ladder", service="Supply & Install", status="Completed"}
    ]>

    <cfset inquiries = [
        {date="2026-08-26", name="Rita Dela Cruz", email="rita@email.com", mobile="0917-221-1090", subject="Installation availability", status="New"},
        {date="2026-08-24", name="Roger Tan", email="roger@email.com", mobile="0919-447-6610", subject="Need a quote for folding ladder", status="Replied"},
        {date="2026-08-20", name="Celine Ramos", email="celine@email.com", mobile="0932-118-9933", subject="Product comparison", status="Closed"}
    ]>

    <cfset galleryItems = [
        {title="Home installation", location="Makati", ladderType="Folding Ladder", order="01", published=true},
        {title="Storage attic upgrade", location="Bacoor", ladderType="Accordion Ladder", order="02", published=true},
        {title="Garage access project", location="Pasig", ladderType="Telescopic Ladder", order="03", published=false},
        {title="Office mezzanine install", location="Quezon City", ladderType="Folding Ladder", order="04", published=true}
    ]>

    <cfset navItems = [
        {key="dashboard", label="Dashboard", icon="bi-grid-1x2-fill"},
        {key="quote-requests", label="Quote Requests", icon="bi-clipboard-check"},
        {key="contact-inquiries", label="Contact Inquiries", icon="bi-envelope-paper"},
        {key="gallery", label="Gallery", icon="bi-images"},
        {key="products", label="Products", icon="bi-box-seam"},
        {key="blog", label="Blog / Articles", icon="bi-journal-text"},
        {key="users", label="Users", icon="bi-people"},
        {key="settings", label="Settings", icon="bi-gear"}
    ]>

    <cfset pageTitles = {
        "dashboard"="Dashboard",
        "quote-requests"="Quote Requests",
        "quote-details"="Quote Details",
        "contact-inquiries"="Contact Inquiries",
        "gallery"="Gallery",
        "products"="Products",
        "blog"="Blog / Articles",
        "users"="Users",
        "settings"="Settings"
    }>

    <cfset viewMap = {
        "dashboard"="Dashboard Overview",
        "quote-requests"="Quote Requests",
        "quote-details"="Quote Details",
        "contact-inquiries"="Contact Inquiries",
        "gallery"="Gallery Management",
        "products"="Products / Attic Ladder Types",
        "blog"="Blog / Articles",
        "users"="Users",
        "settings"="Website Settings"
    }>

    <cfset statusClass = {
        "New"="bg-primary",
        "Contacted"="bg-info",
        "Quoted"="bg-warning text-dark",
        "Scheduled"="bg-success",
        "Completed"="bg-secondary",
        "Cancelled"="bg-danger",
        "Replied"="bg-info",
        "Closed"="bg-dark",
        "Draft"="bg-secondary",
        "Published"="bg-success"
    }>

    <cfset pageHeading = structKeyExists(pageTitles, currentView) ? pageTitles[currentView] : "Dashboard">
    <cfset pageBreadcrumb = structKeyExists(viewMap, currentView) ? viewMap[currentView] : "Dashboard Overview">
</cfsilent>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attic Ladder PH | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: #f5f7fb;
            font-family: Arial, sans-serif;
        }
        .admin-shell {
            min-height: 100vh;
        }
        .sidebar {
            width: 260px;
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            background: #111827;
            color: #fff;
            padding: 1.25rem 1rem;
            z-index: 1000;
        }
        .sidebar-brand {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            padding: 0.75rem 0.5rem 1.25rem;
            border-bottom: 1px solid rgba(255,255,255,0.12);
            margin-bottom: 1rem;
        }
        .brand-mark {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            background: linear-gradient(135deg, #ffc107, #ff8c00);
            color: #111827;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.1rem;
        }
        .sidebar-nav .nav-link {
            color: rgba(255,255,255,0.8);
            border-radius: 10px;
            padding: 0.8rem 0.9rem;
            margin-bottom: 0.25rem;
            display: flex;
            align-items: center;
            gap: 0.7rem;
            font-weight: 500;
        }
        .sidebar-nav .nav-link:hover,
        .sidebar-nav .nav-link.active {
            background: rgba(255,255,255,0.08);
            color: #fff;
        }
        .content {
            margin-left: 260px;
            min-height: 100vh;
        }
        .topbar {
            background: #fff;
            border-bottom: 1px solid #e5e7eb;
            padding: 1rem 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        .page-title {
            margin: 0;
            font-weight: 700;
            color: #1f2937;
        }
        .breadcrumb {
            margin: 0.25rem 0 0;
            background: transparent;
            padding: 0;
            font-size: 0.8rem;
            color: #6b7280;
        }
        .page-shell {
            padding: 1.5rem;
        }
        .card {
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
        }
        .stat-card {
            border-radius: 18px;
            overflow: hidden;
            border: none;
        }
        .stat-card .card-body {
            padding: 1.25rem;
        }
        .stat-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
        }
        .badge {
            font-size: 0.72rem;
            font-weight: 600;
            padding: 0.45rem 0.65rem;
            border-radius: 999px;
        }
        .table thead th {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: #6b7280;
            border-bottom: 1px solid #e5e7eb;
        }
        .table td {
            vertical-align: middle;
        }
        .action-btn {
            border-radius: 10px;
            padding: 0.45rem 0.8rem;
            font-size: 0.82rem;
        }
        .panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        .gallery-card {
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid #e5e7eb;
        }
        .gallery-thumb {
            height: 180px;
            background: linear-gradient(135deg, #dbeafe, #f3f4f6);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #374151;
            font-size: 2.2rem;
        }
        @media (max-width: 991px) {
            .sidebar {
                left: -260px;
                transition: all 0.2s ease;
            }
            .sidebar.show {
                left: 0;
            }
            .content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <cfoutput>
    <div class="admin-shell">
        <aside class="sidebar" id="sidebarMenu">
            <div class="sidebar-brand">
                <div class="brand-mark">AL</div>
                <div>
                    <div class="fw-bold">Attic Ladder PH</div>
                    <small class="text-white-50">Admin Portal</small>
                </div>
            </div>

            <nav class="sidebar-nav">
                <ul class="nav flex-column">
                    <cfloop array="#navItems#" index="item">
                        <li class="nav-item">
                            <a class="nav-link <cfif currentView EQ item.key>active</cfif>" href="index.cfm?view=#urlEncodedFormat(item.key)#">
                                <i class="bi #item.icon#"></i>
                                <span>#htmlEditFormat(item.label)#</span>
                            </a>
                        </li>
                    </cfloop>
                </ul>
            </nav>
        </aside>

        <div class="content">
            <header class="topbar">
                <div class="d-flex align-items-center gap-3">
                    <button class="btn btn-outline-secondary d-lg-none" type="button" data-bs-toggle="offcanvas" data-bs-target="##mobileSidebar">
                        <i class="bi bi-list"></i>
                    </button>
                    <div>
                        <h1 class="page-title">#htmlEditFormat(pageHeading)#</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">Admin</li>
                                <li class="breadcrumb-item active" aria-current="page">#htmlEditFormat(pageBreadcrumb)#</li>
                            </ol>
                        </nav>
                    </div>
                </div>

                <div class="d-flex align-items-center gap-3">
                    <button class="btn btn-light position-relative" type="button" aria-label="Notifications">
                        <i class="bi bi-bell"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">3</span>
                    </button>

                    <div class="dropdown">
                        <button class="btn btn-light dropdown-toggle d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <span class="rounded-circle bg-warning text-dark d-inline-flex align-items-center justify-content-center" style="width:32px;height:32px;font-weight:700;">V</span>
                            <span>
                                <strong>Vladimir</strong><br>
                                <small class="text-muted">Super Admin</small>
                            </span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="##">Profile</a></li>
                            <li><a class="dropdown-item" href="##">Account Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout.cfm">Logout</a></li>
                        </ul>
                    </div>
                </div>
            </header>

            <div class="page-shell">
                <div class="offcanvas offcanvas-start bg-dark text-white" tabindex="-1" id="mobileSidebar" aria-labelledby="mobileSidebarLabel">
                    <div class="offcanvas-header">
                        <h5 class="offcanvas-title" id="mobileSidebarLabel">Attic Ladder PH</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                    </div>
                    <div class="offcanvas-body p-0">
                        <nav class="sidebar-nav p-3">
                            <ul class="nav flex-column">
                                <cfloop array="#navItems#" index="item">
                                    <li class="nav-item">
                                        <a class="nav-link <cfif currentView EQ item.key>active</cfif>" href="index.cfm?view=#urlEncodedFormat(item.key)#">
                                            <i class="bi #item.icon#"></i>
                                            <span>#htmlEditFormat(item.label)#</span>
                                        </a>
                                    </li>
                                </cfloop>
                            </ul>
                        </nav>
                    </div>
                </div>

                <cfswitch expression="#currentView#">
                    <cfcase value="dashboard">
                        <div class="row g-4 mb-4">
                            <cfloop array="#stats#" index="stat">
                                <cfset statClass = "stat-icon bg-" & stat.tone & " bg-opacity-10 text-" & stat.tone>
                                <div class="col-xl-3 col-md-6">
                                    <div class="card stat-card h-100 border-0">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <div class="#statClass#">
                                                    <i class="bi #stat.icon#"></i>
                                                </div>
                                                <span class="badge bg-light text-success">#htmlEditFormat(stat.change)#</span>
                                            </div>
                                            <div class="text-secondary small">#htmlEditFormat(stat.label)#</div>
                                            <div class="display-6 fw-bold mt-2">#htmlEditFormat(stat.value)#</div>
                                        </div>
                                    </div>
                                </div>
                            </cfloop>
                        </div>

                        <div class="row g-4">
                            <div class="col-xl-8">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <div class="panel-header">
                                            <h5 class="mb-0 fw-bold">Recent Quote Requests</h5>
                                            <button class="btn btn-primary btn-sm">View All Quotes</button>
                                        </div>
                                        <div class="table-responsive">
                                            <table class="table align-middle">
                                                <thead>
                                                    <tr>
                                                        <th>Date</th>
                                                        <th>Customer</th>
                                                        <th>Location</th>
                                                        <th>Ladder Type</th>
                                                        <th>Service</th>
                                                        <th>Status</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <cfloop array="#recentQuotes#" index="quote">
                                                        <cfset quoteStatusClass = statusClass[quote.status]>
                                                        <tr>
                                                            <td>#htmlEditFormat(quote.date)#</td>
                                                            <td>#htmlEditFormat(quote.customer)#</td>
                                                            <td>#htmlEditFormat(quote.location)#</td>
                                                            <td>#htmlEditFormat(quote.ladderType)#</td>
                                                            <td>#htmlEditFormat(quote.service)#</td>
                                                            <td><span class="badge #quoteStatusClass#">#htmlEditFormat(quote.status)#</span></td>
                                                            <td><a href="index.cfm?view=quote-requests" class="btn btn-outline-secondary btn-sm action-btn">View</a></td>
                                                        </tr>
                                                    </cfloop>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-4">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <div class="panel-header">
                                            <h5 class="mb-0 fw-bold">Recent Activity</h5>
                                        </div>
                                        <div class="list-group list-group-flush">
                                            <div class="list-group-item px-0 py-3">
                                                <div class="d-flex align-items-start gap-3">
                                                    <span class="rounded-circle bg-primary bg-opacity-10 text-primary d-inline-flex align-items-center justify-content-center" style="width:34px;height:34px;"><i class="bi bi-arrow-down-left-circle"></i></span>
                                                    <div>
                                                        <div class="fw-semibold">New quote request received from Maria Santos</div>
                                                        <small class="text-muted">2 hours ago</small>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="list-group-item px-0 py-3">
                                                <div class="d-flex align-items-start gap-3">
                                                    <span class="rounded-circle bg-success bg-opacity-10 text-success d-inline-flex align-items-center justify-content-center" style="width:34px;height:34px;"><i class="bi bi-image"></i></span>
                                                    <div>
                                                        <div class="fw-semibold">Gallery image uploaded</div>
                                                        <small class="text-muted">Today</small>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="list-group-item px-0 py-3">
                                                <div class="d-flex align-items-start gap-3">
                                                    <span class="rounded-circle bg-warning bg-opacity-10 text-warning d-inline-flex align-items-center justify-content-center" style="width:34px;height:34px;"><i class="bi bi-pencil-square"></i></span>
                                                    <div>
                                                        <div class="fw-semibold">Blog article updated</div>
                                                        <small class="text-muted">Yesterday</small>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="list-group-item px-0 py-3">
                                                <div class="d-flex align-items-start gap-3">
                                                    <span class="rounded-circle bg-info bg-opacity-10 text-info d-inline-flex align-items-center justify-content-center" style="width:34px;height:34px;"><i class="bi bi-calendar-check"></i></span>
                                                    <div>
                                                        <div class="fw-semibold">Quote marked as Scheduled</div>
                                                        <small class="text-muted">2 days ago</small>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="list-group-item px-0 py-3 border-0">
                                                <div class="d-flex align-items-start gap-3">
                                                    <span class="rounded-circle bg-secondary bg-opacity-10 text-secondary d-inline-flex align-items-center justify-content-center" style="width:34px;height:34px;"><i class="bi bi-person-plus"></i></span>
                                                    <div>
                                                        <div class="fw-semibold">New admin user created</div>
                                                        <small class="text-muted">3 days ago</small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfcase>

                    <cfcase value="quote-requests">
                        <div class="card">
                            <div class="card-body">
                                <div class="panel-header flex-wrap gap-3">
                                    <h5 class="mb-0 fw-bold">Quote Requests</h5>
                                    <div class="d-flex flex-wrap gap-2">
                                        <input class="form-control" type="text" placeholder="Search quotes..." style="min-width: 220px;">
                                        <select class="form-select" style="max-width: 160px;">
                                            <option>Status</option>
                                            <option>New</option>
                                            <option>Contacted</option>
                                            <option>Quoted</option>
                                            <option>Scheduled</option>
                                            <option>Completed</option>
                                        </select>
                                        <select class="form-select" style="max-width: 150px;">
                                            <option>Service</option>
                                            <option>Supply Only</option>
                                            <option>Supply & Install</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="table-responsive">
                                    <table class="table align-middle">
                                        <thead>
                                            <tr>
                                                <th>Quote ID</th>
                                                <th>Date</th>
                                                <th>Customer</th>
                                                <th>Mobile</th>
                                                <th>Email</th>
                                                <th>Location</th>
                                                <th>Ladder Type</th>
                                                <th>Service</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <cfloop array="#quoteList#" index="item">
                                                <cfset itemStatusClass = statusClass[item.status]>
                                                <tr>
                                                    <td><strong>#htmlEditFormat(item.id)#</strong></td>
                                                    <td>#htmlEditFormat(item.date)#</td>
                                                    <td>#htmlEditFormat(item.customer)#</td>
                                                    <td>#htmlEditFormat(item.mobile)#</td>
                                                    <td>#htmlEditFormat(item.email)#</td>
                                                    <td>#htmlEditFormat(item.location)#</td>
                                                    <td>#htmlEditFormat(item.ladderType)#</td>
                                                    <td>#htmlEditFormat(item.service)#</td>
                                                    <td><span class="badge #itemStatusClass#">#htmlEditFormat(item.status)#</span></td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="index.cfm?view=quote-details&id=#urlEncodedFormat(item.id)#" class="btn btn-outline-primary btn-sm">View</a>
                                                            <a href="##" class="btn btn-outline-secondary btn-sm">Edit</a>
                                                            <a href="##" class="btn btn-outline-success btn-sm">Status</a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </cfloop>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </cfcase>

                    <cfcase value="quote-details">
                        <div class="card">
                            <div class="card-body">
                                <div class="panel-header">
                                    <h5 class="mb-0 fw-bold">Quote Details</h5>
                                    <div>
                                        <span class="badge bg-primary">ALPH-1001</span>
                                    </div>
                                </div>

                                <div class="row g-4">
                                    <div class="col-lg-6">
                                        <div class="card h-100 bg-light border-0">
                                            <div class="card-body">
                                                <h6 class="fw-bold mb-3">Customer Information</h6>
                                                <dl class="row mb-0">
                                                    <dt class="col-sm-5">Name</dt><dd class="col-sm-7">Maria Santos</dd>
                                                    <dt class="col-sm-5">Mobile Number</dt><dd class="col-sm-7">0917-123-4567</dd>
                                                    <dt class="col-sm-5">Email</dt><dd class="col-sm-7">maria.santos@email.com</dd>
                                                    <dt class="col-sm-5">Address</dt><dd class="col-sm-7">Block 3, Lot 12</dd>
                                                    <dt class="col-sm-5">City / Province</dt><dd class="col-sm-7">Cavite</dd>
                                                </dl>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-lg-6">
                                        <div class="card h-100 bg-light border-0">
                                            <div class="card-body">
                                                <h6 class="fw-bold mb-3">Project Information</h6>
                                                <dl class="row mb-0">
                                                    <dt class="col-sm-5">Ladder Type</dt><dd class="col-sm-7">Folding Ladder</dd>
                                                    <dt class="col-sm-5">Ceiling Height</dt><dd class="col-sm-7">3.2 m</dd>
                                                    <dt class="col-sm-5">Ceiling Opening Size</dt><dd class="col-sm-7">120 x 70 cm</dd>
                                                    <dt class="col-sm-5">Service</dt><dd class="col-sm-7">Supply & Install</dd>
                                                    <dt class="col-sm-5">Preferred Date</dt><dd class="col-sm-7">2026-09-05</dd>
                                                    <dt class="col-sm-5">Customer Notes</dt><dd class="col-sm-7">Needs attic access for storage and occasional maintenance.</dd>
                                                </dl>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row g-4 mt-2">
                                    <div class="col-lg-4">
                                        <div class="card h-100 border-0 bg-light">
                                            <div class="card-body">
                                                <h6 class="fw-bold mb-3">Status</h6>
                                                <select class="form-select">
                                                    <option selected>New</option>
                                                    <option>Contacted</option>
                                                    <option>Quoted</option>
                                                    <option>Scheduled</option>
                                                    <option>Completed</option>
                                                    <option>Cancelled</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-lg-8">
                                        <div class="card h-100 border-0 bg-light">
                                            <div class="card-body">
                                                <h6 class="fw-bold mb-3">Internal Notes</h6>
                                                <textarea class="form-control" rows="5" placeholder="Add internal notes for follow-up, installation planning, or customer communication..."></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap gap-2 mt-4">
                                    <button class="btn btn-primary">Save Changes</button>
                                    <button class="btn btn-outline-primary">Send Quote</button>
                                    <button class="btn btn-outline-secondary">Mark as Contacted</button>
                                    <button class="btn btn-outline-success">Schedule Installation</button>
                                </div>
                            </div>
                        </div>
                    </cfcase>

                    <cfcase value="contact-inquiries">
                        <div class="card">
                            <div class="card-body">
                                <div class="panel-header">
                                    <h5 class="mb-0 fw-bold">Contact Inquiries</h5>
                                </div>
                                <div class="table-responsive">
                                    <table class="table align-middle">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Mobile</th>
                                                <th>Subject</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <cfloop array="#inquiries#" index="inquiry">
                                                <cfset inquiryStatusClass = statusClass[inquiry.status]>
                                                <tr>
                                                    <td>#htmlEditFormat(inquiry.date)#</td>
                                                    <td>#htmlEditFormat(inquiry.name)#</td>
                                                    <td>#htmlEditFormat(inquiry.email)#</td>
                                                    <td>#htmlEditFormat(inquiry.mobile)#</td>
                                                    <td>#htmlEditFormat(inquiry.subject)#</td>
                                                    <td><span class="badge #inquiryStatusClass#">#htmlEditFormat(inquiry.status)#</span></td>
                                                    <td><button class="btn btn-outline-secondary btn-sm">Reply</button></td>
                                                </tr>
                                            </cfloop>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </cfcase>

                    <cfcase value="gallery">
                        <div class="card">
                            <div class="card-body">
                                <div class="panel-header">
                                    <h5 class="mb-0 fw-bold">Gallery Management</h5>
                                    <button class="btn btn-primary">Add Photo</button>
                                </div>
                                <div class="row g-4">
                                    <cfloop array="#galleryItems#" index="item">
                                        <cfset galleryStatus = item.published ? "Published" : "Draft">
                                        <cfset galleryStatusClass = statusClass[galleryStatus]>
                                        <div class="col-md-6 col-xl-3">
                                            <div class="gallery-card h-100">
                                                <div class="gallery-thumb">
                                                    <i class="bi bi-image"></i>
                                                </div>
                                                <div class="p-3">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <h6 class="mb-0 fw-bold">#htmlEditFormat(item.title)#</h6>
                                                        <span class="badge #galleryStatusClass#">#htmlEditFormat(galleryStatus)#</span>
                                                    </div>
                                                    <p class="text-muted small mb-1">Location: #htmlEditFormat(item.location)#</p>
                                                    <p class="text-muted small mb-1">Ladder Type: #htmlEditFormat(item.ladderType)#</p>
                                                    <p class="text-muted small mb-0">Display Order: #htmlEditFormat(item.order)#</p>
                                                </div>
                                            </div>
                                        </div>
                                    </cfloop>
                                </div>
                            </div>
                        </div>
                    </cfcase>

                    <cfcase value="products">
                        <div class="card">
                            <div class="card-body">
                                <div class="panel-header">
                                    <h5 class="mb-0 fw-bold">Products / Attic Ladder Types</h5>
                                    <button class="btn btn-primary">Add Product</button>
                                </div>
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <div class="card h-100 border-0 bg-light">
                                            <div class="card-body">
                                                <h6 class="fw-bold">Folding Ladder</h6>
                                                <p class="text-muted mb-3">Space-saving, durable, and ideal for residential attic access.</p>
                                                <div class="d-flex justify-content-between small text-muted"><span>Price</span><strong>₱18,500</strong></div>
                                                <div class="d-flex justify-content-between small text-muted mt-2"><span>Inventory</span><strong>12 units</strong></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="card h-100 border-0 bg-light">
                                            <div class="card-body">
                                                <h6 class="fw-bold">Accordion Ladder</h6>
                                                <p class="text-muted mb-3">Compact design with smooth operation for smaller ceiling openings.</p>
                                                <div class="d-flex justify-content-between small text-muted"><span>Price</span><strong>₱22,000</strong></div>
                                                <div class="d-flex justify-content-between small text-muted mt-2"><span>Inventory</span><strong>8 units</strong></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfcase>

                    <cfcase value="blog">
                        <div class="card">
                            <div class="card-body">
                                <div class="panel-header">
                                    <h5 class="mb-0 fw-bold">Blog / Articles</h5>
                                    <button class="btn btn-primary">New Article</button>
                                </div>
                                <div class="list-group">
                                    <div class="list-group-item">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1">Why Homeowners Choose Attic Ladders</h6>
                                                <small class="text-muted">Published • August 18, 2026</small>
                                            </div>
                                            <span class="badge bg-success">Published</span>
                                        </div>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1">How to Measure Your Ceiling Opening</h6>
                                                <small class="text-muted">Draft • August 14, 2026</small>
                                            </div>
                                            <span class="badge bg-secondary">Draft</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfcase>

                    <cfcase value="users">
                        <div class="card">
                            <div class="card-body">
                                <div class="panel-header">
                                    <h5 class="mb-0 fw-bold">Users</h5>
                                    <button class="btn btn-primary">Add User</button>
                                </div>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Role</th>
                                                <th>Status</th>
                                                <th>Last Login</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Vladimir</td>
                                                <td>Super Admin</td>
                                                <td><span class="badge bg-success">Active</span></td>
                                                <td>Today</td>
                                            </tr>
                                            <tr>
                                                <td>Mary Jane</td>
                                                <td>Sales Admin</td>
                                                <td><span class="badge bg-success">Active</span></td>
                                                <td>Yesterday</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </cfcase>

                    <cfcase value="settings">
                        <div class="card">
                            <div class="card-body">
                                <div class="panel-header">
                                    <h5 class="mb-0 fw-bold">Website Settings</h5>
                                </div>
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <label class="form-label">Business Name</label>
                                        <input class="form-control" type="text" value="Attic Ladder PH">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Phone Number</label>
                                        <input class="form-control" type="text" value="(02) 8123-4567">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Email Address</label>
                                        <input class="form-control" type="email" value="hello@atticladderph.com">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Company Location</label>
                                        <input class="form-control" type="text" value="Metro Manila, Philippines">
                                    </div>
                                    <div class="col-12">
                                        <button class="btn btn-primary">Save Settings</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfcase>
                </cfswitch>
            </div>
        </div>
    </div>

    </cfoutput>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

