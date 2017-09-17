# README
<h1>Mikrotik Hotspot Wifi Service</H1>
<h2>Installation</h2>
<ul>
<li>Get repository </li>
<li>Install gems: bundle install</li>
<li>Edit yml configs</li>
<li>Create database: rake db:create</li>
<li>Append migrations: rails db:migrate</li>
<li>Run service in production env: 
<ul>
<li>rake assets:precompile</li>
<li>rails s -b ip-address -e production</li>
</ul>
</li>
<li>Success!</li>
</ul>

<h3>
Ruby 2.3.*
Rails 5.1
MySQL DB
</h3>

<h3>Admin access</h3>
<p>Create user: request to url - /users/sign_up. After registration edit record in database: find record by email, set admin column "1". Log in <p>
