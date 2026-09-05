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
        {key="create-quote", label="Create Quote", icon="bi-file-earmark-plus"},
        {key="code-generation", label="Code Generation", icon="bi-code-slash"},
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
        "create-quote"="Create Quote",
        "code-generation"="Code Generation",
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
        "create-quote"="Create Quote Generator",
        "code-generation"="Code & Quote Generation",
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
                                            <div class="d-flex gap-2">
                                                <a href="index.cfm?view=create-quote" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Create Quote</a>
                                                <a href="index.cfm?view=quote-requests" class="btn btn-outline-secondary btn-sm">View All Quotes</a>
                                            </div>
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
                                        <a href="index.cfm?view=create-quote" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Create Quote</a>
                                        <a href="index.cfm?view=code-generation" class="btn btn-outline-primary btn-sm"><i class="bi bi-code-slash me-1"></i>Code Generator</a>
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

                    <cfcase value="create-quote">
                        <div class="row g-4 mb-4">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body">
                                        <div class="panel-header flex-wrap gap-2">
                                            <div>
                                                <h5 class="mb-1 fw-bold"><i class="bi bi-file-earmark-plus text-primary me-2"></i>Create New Quote</h5>
                                                <p class="text-muted small mb-0">Fill out client information and standard attic ladder specifications to generate a formal quote & code.</p>
                                            </div>
                                            <div class="d-flex gap-2">
                                                <a href="index.cfm?view=quote-requests" class="btn btn-outline-secondary btn-sm">
                                                    <i class="bi bi-arrow-left me-1"></i>Quote Requests
                                                </a>
                                                <a href="index.cfm?view=code-generation" class="btn btn-outline-primary btn-sm">
                                                    <i class="bi bi-code-slash me-1"></i>Code Generation Tool
                                                </a>
                                            </div>
                                        </div>

                                        <cfif structKeyExists(form, "submit_quote")>
                                            <cfparam name="form.client_name" default="">
                                            <cfparam name="form.client_phone" default="">
                                            <cfparam name="form.client_address" default="">
                                            <cfparam name="form.ladder_size" default="">
                                            <cfparam name="form.ladder_type" default="Folding Ladder">
                                            <cfparam name="form.service_type" default="Supply & Install">
                                            <cfparam name="form.quote_price" default="18500">
                                            <cfparam name="form.quote_notes" default="">

                                            <cfset generatedCode = "ALPH-Q" & dateFormat(now(), "yyyy") & randRange(1000, 9999)>

                                            <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-check-circle-fill fs-4"></i>
                                                    <div>
                                                        <strong>Quote Created Successfully!</strong> Reference Code: <code>#htmlEditFormat(generatedCode)#</code> for #htmlEditFormat(form.client_name)# (#htmlEditFormat(form.ladder_size)#)
                                                    </div>
                                                </div>
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </cfif>

                                        <form id="createQuoteForm" method="post" action="index.cfm?view=create-quote">
                                            <div class="row g-4">
                                                <!-- Client Details -->
                                                <div class="col-lg-6">
                                                    <div class="card h-100 bg-light border-0">
                                                        <div class="card-body">
                                                            <h6 class="fw-bold text-dark mb-3">
                                                                <i class="bi bi-person-badge text-primary me-2"></i>Client Information
                                                            </h6>
                                                            
                                                            <div class="mb-3">
                                                                <label for="client_name" class="form-label fw-semibold">Client's Name <span class="text-danger">*</span></label>
                                                                <input type="text" class="form-control" id="client_name" name="client_name" placeholder="e.g. Maria Santos" required value="<cfif structKeyExists(form, 'client_name')>#htmlEditFormat(form.client_name)#</cfif>">
                                                            </div>

                                                            <div class="mb-3">
                                                                <label for="client_phone" class="form-label fw-semibold">Phone Number / Mobile <span class="text-danger">*</span></label>
                                                                <input type="tel" class="form-control" id="client_phone" name="client_phone" placeholder="e.g. 0917-123-4567" required value="<cfif structKeyExists(form, 'client_phone')>#htmlEditFormat(form.client_phone)#</cfif>">
                                                            </div>

                                                            <div class="mb-3">
                                                                <label for="client_address" class="form-label fw-semibold">Client Address <span class="text-danger">*</span></label>
                                                                <textarea class="form-control" id="client_address" name="client_address" rows="3" placeholder="e.g. Block 3, Lot 12, Sunrise Street, Cavite" required><cfif structKeyExists(form, 'client_address')>#htmlEditFormat(form.client_address)#</cfif></textarea>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Specifications & Sizes -->
                                                <div class="col-lg-6">
                                                    <div class="card h-100 bg-light border-0">
                                                        <div class="card-body">
                                                            <h6 class="fw-bold text-dark mb-3">
                                                                <i class="bi bi-tools text-primary me-2"></i>Attic Ladder Specifications
                                                            </h6>

                                                            <div class="mb-3">
                                                                <label for="ladder_size" class="form-label fw-semibold">Standard Opening Size <span class="text-danger">*</span></label>
                                                                <select class="form-select" id="ladder_size" name="ladder_size" required>
                                                                    <option value="" disabled <cfif NOT structKeyExists(form, 'ladder_size') OR form.ladder_size EQ "">selected</cfif>>-- Select Standard Size --</option>
                                                                    <option value="70cm x 90cm" <cfif structKeyExists(form, 'ladder_size') AND form.ladder_size EQ "70cm x 90cm">selected</cfif>>70cm x 90cm</option>
                                                                    <option value="70cm x 100cm" <cfif structKeyExists(form, 'ladder_size') AND form.ladder_size EQ "70cm x 100cm">selected</cfif>>70cm x 100cm</option>
                                                                    <option value="70cm x 120cm" <cfif structKeyExists(form, 'ladder_size') AND form.ladder_size EQ "70cm x 120cm">selected</cfif>>70cm x 120cm</option>
                                                                    <option value="80cm x 100cm" <cfif structKeyExists(form, 'ladder_size') AND form.ladder_size EQ "80cm x 100cm">selected</cfif>>80cm x 100cm</option>
                                                                    <option value="80cm x 120cm" <cfif structKeyExists(form, 'ladder_size') AND form.ladder_size EQ "80cm x 120cm">selected</cfif>>80cm x 120cm</option>
                                                                </select>
                                                                <div class="form-text">Choose one of the standard opening sizes.</div>
                                                            </div>

                                                            <div class="row g-2 mb-3">
                                                                <div class="col-md-6">
                                                                    <label for="ladder_type" class="form-label fw-semibold">Ladder Type</label>
                                                                    <select class="form-select" id="ladder_type" name="ladder_type">
                                                                        <option value="Folding Ladder">Folding Ladder</option>
                                                                        <option value="Accordion Ladder">Accordion Ladder</option>
                                                                        <option value="Telescopic Ladder">Telescopic Ladder</option>
                                                                        <option value="Luxury Aluminium Ladder">Luxury Aluminium Ladder</option>
                                                                    </select>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label for="service_type" class="form-label fw-semibold">Service Required</label>
                                                                    <select class="form-select" id="service_type" name="service_type">
                                                                        <option value="Supply & Install">Supply & Install</option>
                                                                        <option value="Supply Only">Supply Only</option>
                                                                    </select>
                                                                </div>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label for="quote_price" class="form-label fw-semibold">Estimated Price (PHP)</label>
                                                                <div class="input-group">
                                                                    <span class="input-group-text">₱</span>
                                                                    <input type="number" class="form-control" id="quote_price" name="quote_price" placeholder="18500" value="<cfif structKeyExists(form, 'quote_price')>#htmlEditFormat(form.quote_price)#<cfelse>18500</cfif>">
                                                                </div>
                                                            </div>

                                                            <div class="mb-0">
                                                                <label for="quote_notes" class="form-label fw-semibold">Notes / Special Instructions</label>
                                                                <textarea class="form-control" id="quote_notes" name="quote_notes" rows="2" placeholder="e.g. Standard ceiling height 2.8m, free delivery within Cavite"></textarea>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="d-flex flex-wrap gap-2 mt-4">
                                                <button type="button" class="btn btn-primary btn-lg" id="btnGenerateQuoteCode">
                                                    <i class="bi bi-code-slash me-1"></i>Generate Code & Preview
                                                </button>
                                                <button type="submit" name="submit_quote" class="btn btn-success btn-lg">
                                                    <i class="bi bi-check-lg me-1"></i>Save Quote
                                                </button>
                                                <button type="reset" class="btn btn-outline-secondary btn-lg">
                                                    <i class="bi bi-arrow-counterclockwise me-1"></i>Reset Form
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Generated Code & Output Card -->
                        <div class="card mt-4" id="quoteOutputCard" style="display:none;">
                            <div class="card-body">
                                <div class="panel-header">
                                    <h5 class="mb-0 fw-bold"><i class="bi bi-terminal-box text-success me-2"></i>Generated Code & Quote Output</h5>
                                    <button class="btn btn-sm btn-outline-secondary" onclick="copyQuoteOutput('quoteTextMessage')">
                                        <i class="bi bi-clipboard me-1"></i>Copy Message Code
                                    </button>
                                </div>

                                <ul class="nav nav-tabs mb-3" id="quoteCodeTabs" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="tab-text-tab" data-bs-toggle="tab" data-bs-target="##tab-text" type="button" role="tab">Message Text Code</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="tab-html-tab" data-bs-toggle="tab" data-bs-target="##tab-html" type="button" role="tab">HTML Embed Code</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="tab-json-tab" data-bs-toggle="tab" data-bs-target="##tab-json" type="button" role="tab">JSON Data Code</button>
                                    </li>
                                </ul>

                                <div class="tab-content p-3 bg-light rounded-3 border">
                                    <div class="tab-pane fade show active" id="tab-text" role="tabpanel">
                                        <pre id="quoteTextMessage" class="mb-0 font-monospace text-dark" style="white-space: pre-wrap; font-size: 0.9rem;"></pre>
                                    </div>
                                    <div class="tab-pane fade" id="tab-html" role="tabpanel">
                                        <pre id="quoteHtmlCode" class="mb-0 font-monospace text-dark" style="white-space: pre-wrap; font-size: 0.85rem;"></pre>
                                    </div>
                                    <div class="tab-pane fade" id="tab-json" role="tabpanel">
                                        <pre id="quoteJsonCode" class="mb-0 font-monospace text-dark" style="white-space: pre-wrap; font-size: 0.85rem;"></pre>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfcase>

                    <cfcase value="code-generation">
                        <div class="card">
                            <div class="card-body">
                                <div class="panel-header flex-wrap gap-2 mb-3">
                                    <div>
                                        <h5 class="mb-1 fw-bold"><i class="bi bi-code-slash text-primary me-2"></i>Code Generation Hub</h5>
                                        <p class="text-muted small mb-0">Generate quote codes, customer communication templates, and HTML code snippets for website integration.</p>
                                    </div>
                                    <a href="index.cfm?view=create-quote" class="btn btn-primary btn-sm">
                                        <i class="bi bi-file-earmark-plus me-1"></i>Create New Quote
                                    </a>
                                </div>

                                <ul class="nav nav-pills mb-4" id="codeGenTabs" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="gen-quote-tab" data-bs-toggle="pill" data-bs-target="##gen-quote" type="button" role="tab">
                                            <i class="bi bi-receipt me-1"></i>Quote Code Generator
                                        </button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="gen-embed-tab" data-bs-toggle="pill" data-bs-target="##gen-embed" type="button" role="tab">
                                            <i class="bi bi-box-arrow-up-right me-1"></i>Website Button Embed Code
                                        </button>
                                    </li>
                                </ul>

                                <div class="tab-content" id="codeGenTabContent">
                                    <!-- Quote Code Generator -->
                                    <div class="tab-pane fade show active" id="gen-quote" role="tabpanel">
                                        <div class="row g-4">
                                            <div class="col-lg-6">
                                                <div class="card bg-light border-0">
                                                    <div class="card-body">
                                                        <h6 class="fw-bold mb-3">Quick Quote Code Generator</h6>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Client Name</label>
                                                            <input type="text" id="cg_name" class="form-control" placeholder="e.g. Maria Santos">
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Phone Number</label>
                                                            <input type="tel" id="cg_phone" class="form-control" placeholder="e.g. 0917-123-4567">
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Address</label>
                                                            <input type="text" id="cg_address" class="form-control" placeholder="e.g. Alabang, Muntinlupa">
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Standard Opening Size</label>
                                                            <select id="cg_size" class="form-select">
                                                                <option value="" disabled selected>-- Select Standard Size --</option>
                                                                <option value="70cm x 90cm">70cm x 90cm</option>
                                                                <option value="70cm x 100cm">70cm x 100cm</option>
                                                                <option value="70cm x 120cm">70cm x 120cm</option>
                                                                <option value="80cm x 100cm">80cm x 100cm</option>
                                                                <option value="80cm x 120cm">80cm x 120cm</option>
                                                            </select>
                                                        </div>
                                                        <button type="button" class="btn btn-primary w-100" onclick="generateCgQuoteCode()">
                                                            <i class="bi bi-gear-wide-connected me-1"></i>Generate Code
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-lg-6">
                                                <div class="card border">
                                                    <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                                                        <span class="fw-semibold small"><i class="bi bi-code me-1"></i>Generated Quote Code Output</span>
                                                        <button class="btn btn-xs btn-outline-light" onclick="copyCodeElement('cg_code_output')">Copy Code</button>
                                                    </div>
                                                    <div class="card-body bg-light">
                                                        <pre id="cg_code_output" class="mb-0 font-monospace small" style="white-space: pre-wrap; min-height: 220px;">// Fill the form on the left and click "Generate Code"...</pre>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Embed Button Generator -->
                                    <div class="tab-pane fade" id="gen-embed" role="tabpanel">
                                        <div class="row g-4">
                                            <div class="col-lg-6">
                                                <div class="card bg-light border-0">
                                                    <div class="card-body">
                                                        <h6 class="fw-bold mb-3">Configure Embed Button</h6>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Button Text</label>
                                                            <input type="text" id="eb_text" class="form-control" value="Request a Free Quote">
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Default Size Pre-selection</label>
                                                            <select id="eb_size" class="form-select">
                                                                <option value="">Any Size</option>
                                                                <option value="70cm x 90cm">70cm x 90cm</option>
                                                                <option value="70cm x 100cm">70cm x 100cm</option>
                                                                <option value="70cm x 120cm">70cm x 120cm</option>
                                                                <option value="80cm x 100cm">80cm x 100cm</option>
                                                                <option value="80cm x 120cm">80cm x 120cm</option>
                                                            </select>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Button Style</label>
                                                            <select id="eb_style" class="form-select">
                                                                <option value="btn btn-warning">Gold Warning Button</option>
                                                                <option value="btn btn-primary">Primary Blue Button</option>
                                                                <option value="btn btn-success">Success Green Button</option>
                                                            </select>
                                                        </div>
                                                        <button type="button" class="btn btn-primary w-100" onclick="generateEmbedCode()">
                                                            <i class="bi bi-code-square me-1"></i>Generate Embed Code
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-lg-6">
                                                <div class="card border">
                                                    <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                                                        <span class="fw-semibold small"><i class="bi bi-file-earmark-code me-1"></i>HTML Embed Code Snippet</span>
                                                        <button class="btn btn-xs btn-outline-light" onclick="copyCodeElement('eb_code_output')">Copy Code</button>
                                                    </div>
                                                    <div class="card-body bg-light">
                                                        <pre id="eb_code_output" class="mb-0 font-monospace small" style="white-space: pre-wrap; min-height: 220px;">// Click "Generate Embed Code" to get HTML button code snippet...</pre>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
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
    <script>
        function generateQuotePreview() {
            var clientName = document.getElementById('client_name') ? document.getElementById('client_name').value.trim() : '';
            var clientPhone = document.getElementById('client_phone') ? document.getElementById('client_phone').value.trim() : '';
            var clientAddress = document.getElementById('client_address') ? document.getElementById('client_address').value.trim() : '';
            var ladderSize = document.getElementById('ladder_size') ? document.getElementById('ladder_size').value : '';
            var ladderType = document.getElementById('ladder_type') ? document.getElementById('ladder_type').value : 'Folding Ladder';
            var serviceType = document.getElementById('service_type') ? document.getElementById('service_type').value : 'Supply & Install';
            var quotePrice = document.getElementById('quote_price') ? document.getElementById('quote_price').value.trim() : '18500';
            var quoteNotes = document.getElementById('quote_notes') ? document.getElementById('quote_notes').value.trim() : '';

            if (!clientName || !clientPhone || !clientAddress || !ladderSize) {
                alert('Please fill out Client Name, Phone Number, Address, and select a Standard Opening Size.');
                return;
            }

            var refCode = 'ALPH-Q' + new Date().getFullYear() + '-' + Math.floor(1000 + Math.random() * 9000);
            
            // Text Message Code
            var msg = "====================================\n";
            msg += "  ATTIC LADDER PH - OFFICIAL QUOTE\n";
            msg += "====================================\n";
            msg += "Quote Ref    : " + refCode + "\n";
            msg += "Date         : " + new Date().toLocaleDateString() + "\n\n";
            msg += "CLIENT INFORMATION:\n";
            msg += "Name         : " + clientName + "\n";
            msg += "Phone        : " + clientPhone + "\n";
            msg += "Address      : " + clientAddress + "\n\n";
            msg += "ATTIC LADDER SPECIFICATIONS:\n";
            msg += "Opening Size : " + ladderSize + "\n";
            msg += "Model Type   : " + ladderType + "\n";
            msg += "Service      : " + serviceType + "\n";
            msg += "Est. Total   : PHP " + Number(quotePrice).toLocaleString('en-US') + "\n";
            if (quoteNotes) {
                msg += "Notes        : " + quoteNotes + "\n";
            }
            msg += "\nThank you for choosing Attic Ladder PH!";

            // HTML Code
            var html = '<div class="attic-quote-card" style="border:1px solid #e5e7eb;padding:20px;border-radius:12px;background:#ffffff;">\n';
            html += '  <h4 style="color:#111827;margin-top:0;">Attic Ladder PH Quote (' + refCode + ')</h4>\n';
            html += '  <p><strong>Client:</strong> ' + clientName + ' | ' + clientPhone + '</p>\n';
            html += '  <p><strong>Address:</strong> ' + clientAddress + '</p>\n';
            html += '  <hr style="border:0;border-top:1px solid #eee;">\n';
            html += '  <p><strong>Opening Size:</strong> ' + ladderSize + '</p>\n';
            html += '  <p><strong>Ladder Model:</strong> ' + ladderType + '</p>\n';
            html += '  <p><strong>Service:</strong> ' + serviceType + '</p>\n';
            html += '  <p><strong>Estimated Price:</strong> PHP ' + Number(quotePrice).toLocaleString('en-US') + '</p>\n';
            html += '</div>';

            // JSON Code
            var jsonObj = {
                quoteRef: refCode,
                date: new Date().toISOString().split('T')[0],
                client: {
                    name: clientName,
                    phone: clientPhone,
                    address: clientAddress
                },
                specifications: {
                    openingSize: ladderSize,
                    ladderType: ladderType,
                    service: serviceType,
                    estimatedPricePhp: Number(quotePrice),
                    notes: quoteNotes
                }
            };

            document.getElementById('quoteTextMessage').textContent = msg;
            document.getElementById('quoteHtmlCode').textContent = html;
            document.getElementById('quoteJsonCode').textContent = JSON.stringify(jsonObj, null, 2);

            var outputCard = document.getElementById('quoteOutputCard');
            if (outputCard) {
                outputCard.style.display = 'block';
                outputCard.scrollIntoView({ behavior: 'smooth' });
            }
        }

        function copyQuoteOutput(elementId) {
            var text = document.getElementById(elementId).textContent;
            navigator.clipboard.writeText(text).then(function() {
                alert('Copied to clipboard!');
            });
        }

        function copyCodeElement(elementId) {
            var text = document.getElementById(elementId).textContent;
            if (text.startsWith('//')) {
                alert('Please generate code first.');
                return;
            }
            navigator.clipboard.writeText(text).then(function() {
                alert('Code copied to clipboard!');
            });
        }

        function generateCgQuoteCode() {
            var name = document.getElementById('cg_name').value.trim() || 'Client Name';
            var phone = document.getElementById('cg_phone').value.trim() || '0917-000-0000';
            var address = document.getElementById('cg_address').value.trim() || 'Client Address';
            var size = document.getElementById('cg_size').value || '70cm x 120cm';

            var code = "<!-- Attic Ladder PH Generated Quote Snippet -->\n";
            code += '<div class="quote-snippet" data-size="' + size + '">\n';
            code += '  <span class="quote-client">' + name + '</span>\n';
            code += '  <span class="quote-phone">' + phone + '</span>\n';
            code += '  <span class="quote-address">' + address + '</span>\n';
            code += '  <span class="quote-size">Size: ' + size + '</span>\n';
            code += '</div>';

            document.getElementById('cg_code_output').textContent = code;
        }

        function generateEmbedCode() {
            var text = document.getElementById('eb_text').value.trim() || 'Request a Free Quote';
            var size = document.getElementById('eb_size').value;
            var style = document.getElementById('eb_style').value;

            var url = 'quoterequest.cfm';
            if (size) {
                url += '?size=' + encodeURIComponent(size);
            }

            var embed = '<a href="' + url + '" class="' + style + '">\n';
            embed += '  <i class="bi bi-chat-quote-fill me-2"></i>' + text + '\n';
            embed += '</a>';

            document.getElementById('eb_code_output').textContent = embed;
        }

        document.addEventListener('DOMContentLoaded', function() {
            var btnGen = document.getElementById('btnGenerateQuoteCode');
            if (btnGen) {
                btnGen.addEventListener('click', generateQuotePreview);
            }
        });
    </script>
</body>
</html>

