import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ClaimsService, Claim } from './claims.service';

@Component({
  selector: 'app-claim-details',
  templateUrl: './claim-details.component.html',
  styleUrls: ['./claim-details.component.scss']
})
export class ClaimDetailsComponent implements OnInit {
  claim: Claim | null = null;
  loading = true;

  constructor(
    private claimsService: ClaimsService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    const id = +this.route.snapshot.params['id'];
    this.claimsService.getClaim(id).subscribe(claim => {
      this.claim = claim;
      this.loading = false;
    });
  }

  goBack() {
    this.router.navigate(['/claims']);
  }

  editClaim() {
    if (this.claim) {
      this.router.navigate(['/claims/edit', this.claim.id]);
    }
  }
}
