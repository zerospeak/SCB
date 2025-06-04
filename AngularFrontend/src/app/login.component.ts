import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from './auth.service';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  loginForm: FormGroup;
  error: string | null = null;
  submitting = false;

  constructor(
    private fb: FormBuilder,
    private auth: AuthService,
    private router: Router
  ) {
    this.loginForm = this.fb.group({
      username: ['', Validators.required],
      password: ['', Validators.required]
    });
  }

  onSubmit() {
    this.error = null;
    if (this.loginForm.invalid) return;
    this.submitting = true;
    const { username, password } = this.loginForm.value;
    this.auth.login(username, password).subscribe({
      next: (success) => {
        this.submitting = false;
        if (success) {
          this.router.navigate(['/claims']);
        } else {
          this.error = 'Invalid username or password.';
        }
      },
      error: () => {
        this.submitting = false;
        this.error = 'Invalid username or password.';
      }
    });
  }
}
