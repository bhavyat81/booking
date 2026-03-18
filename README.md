# booking
app

## EmailJS Setup (Auto-Send Booking Emails)

When a booking is submitted, the app automatically sends the booking details to **josemon619@gmail.com** via the [EmailJS](https://www.emailjs.com/) REST API — no email app is opened and no user interaction is required.

### Steps to configure EmailJS

1. **Create a free account** at [emailjs.com](https://www.emailjs.com/).

2. **Add an email service**
   - In the EmailJS dashboard, go to **Email Services** → **Add New Service**.
   - Choose **Gmail** (or any provider) and connect your account.
   - Copy the **Service ID** (e.g. `service_abc123`).

3. **Create an email template**
   - Go to **Email Templates** → **Create New Template**.
   - Use the following variables in the template body:
     `{{passenger_name}}`, `{{booking_reference}}`, `{{selected_date}}`,
     `{{route}}`, `{{departure_time}}`, `{{phone}}`, `{{email}}`,
     `{{num_bags}}`, `{{pickup_address}}`, `{{dropoff_address}}`, `{{message}}`
   - Set **To Email** to `{{to_email}}` and **Subject** to `{{subject}}`.
   - Copy the **Template ID** (e.g. `template_xyz456`).

4. **Get your Public Key**
   - Go to **Account** → **General** and copy your **Public Key** (e.g. `user_XXXXX`).

5. **Update `scripts/email_sender.gd`**
   Replace the placeholder constants at the top of the file:
   ```gdscript
   const EMAILJS_SERVICE_ID  = "service_abc123"   # your Service ID
   const EMAILJS_TEMPLATE_ID = "template_xyz456"  # your Template ID
   const EMAILJS_PUBLIC_KEY  = "user_XXXXX"       # your Public Key
   ```

Once configured, every booking submission will silently POST to the EmailJS API and deliver the booking details to josemon619@gmail.com.
