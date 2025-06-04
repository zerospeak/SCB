import { Component } from '@angular/core';
import { AuthService } from './auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-root',
  template: `
    <mat-toolbar color="primary">
      <span style="font-weight: bold; cursor: pointer;" (click)="goHome()">HealthGuard</span>
      <span class="spacer"></span>
      <a mat-button routerLink="/claims">Claims</a>
      <a mat-button routerLink="/claims/new">New Claim</a>
      <a mat-button routerLink="/login" *ngIf="!auth.isAuthenticated()">Login</a>
      <button mat-button (click)="logout()" *ngIf="auth.isAuthenticated()">Logout</button>
    </mat-toolbar>
    <router-outlet></router-outlet>
  `,
  styles: [`.spacer { flex: 1 1 auto; }`]
})
export class AppComponent {
  constructor(public auth: AuthService, private router: Router) {}
  logout() {
    this.auth.logout();
  }
  goHome() {
    this.router.navigate(['/claims']);
  }
}
