import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { RouterModule, Routes } from '@angular/router';
import { MatDividerModule } from '@angular/material/divider';
import { MatIconModule } from '@angular/material/icon';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { AuthInterceptor } from './auth.interceptor';

// Angular Material Modules
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatTableModule } from '@angular/material/table';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatNativeDateModule } from '@angular/material/core';
import { MatProgressBarModule } from '@angular/material/progress-bar';

import { ClaimsListComponent } from './claims/claims-list.component';
import { ClaimFormComponent } from './claims/claim-form.component';
import { ClaimDetailsComponent } from './claims/claim-details.component';
import { LoginComponent } from './login.component';
import { AuthGuard } from './auth.guard';

import { HealthComponent } from './health.component';

const routes: Routes = [
  { path: '', redirectTo: 'claims', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'claims', component: ClaimsListComponent, canActivate: [AuthGuard] },
  { path: 'claims/new', component: ClaimFormComponent, canActivate: [AuthGuard] },
  { path: 'claims/edit/:id', component: ClaimFormComponent, canActivate: [AuthGuard] },
  { path: 'claims/:id', component: ClaimDetailsComponent, canActivate: [AuthGuard] },
  { path: 'health', component: HealthComponent },
];

@NgModule({
  declarations: [
    AppComponent,
    ClaimsListComponent,
    ClaimFormComponent,
    ClaimDetailsComponent,
    LoginComponent,
    HealthComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    RouterModule.forRoot(routes),
    MatDividerModule,
    MatIconModule,
    MatToolbarModule,
    MatButtonModule,
    MatTableModule,
    MatCardModule,
    MatFormFieldModule,
    MatInputModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatProgressBarModule
  ],
  providers: [
    { provide: HTTP_INTERCEPTORS, useClass: AuthInterceptor, multi: true }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
