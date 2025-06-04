import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ClaimsService, Claim } from './claims.service';

@Component({
  selector: 'app-claims-list',
  templateUrl: './claims-list.component.html',
  styleUrls: ['./claims-list.component.scss']
})
export class ClaimsListComponent implements OnInit {
  claims: Claim[] = [];
  loading = true;

  constructor(private claimsService: ClaimsService, private router: Router) {}

  ngOnInit(): void {
    this.loadClaims();
  }

  loadClaims() {
    this.loading = true;
    this.claimsService.getClaims().subscribe(data => {
      this.claims = data;
      this.loading = false;
    });
  }

  createClaim() {
    this.router.navigate(['/claims/new']);
  }

  viewClaim(id: number) {
    this.router.navigate(['/claims', id]);
  }

  editClaim(id: number) {
    this.router.navigate(['/claims/edit', id]);
  }

  deleteClaim(id: number) {
    this.claimsService.deleteClaim(id).subscribe(() => this.loadClaims());
  }
}
