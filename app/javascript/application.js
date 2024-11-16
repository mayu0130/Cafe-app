import { Turbo } from "@hotwired/turbo-rails";
import "@rails/ujs";

Rails.start();
Turbo.session.drive = true;