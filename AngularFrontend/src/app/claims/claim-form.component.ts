import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ClaimsService, Claim } from './claims.service';

@Component({
  selector: 'app-claim-form',
  templateUrl: './claim-form.component.html',
  styleUrls: ['./claim-form.component.scss']
})
export class ClaimFormComponent implements OnInit {
  claimForm: FormGroup;
  isEdit = false;
  claimId: number | null = null;
  loading = false;
  submitted = false;

  constructor(
    private fb: FormBuilder,
    private claimsService: ClaimsService,
    private route: ActivatedRoute,
    private router: Router
  ) {
    this.claimForm = this.fb.group({
      claimNumber: ['', Validators.required],
      policyHolder: ['', Validators.required],
      date: ['', Validators.required],
      status: ['', Validators.required],
      amount: [0, [Validators.required, Validators.min(0)]]
    });
  }

  ngOnInit(): void {
    this.claimId = this.route.snapshot.params['id'] ? +this.route.snapshot.params['id'] : null;
    if (this.claimId) {
      this.isEdit = true;
      this.loading = true;
      this.claimsService.getClaim(this.claimId).subscribe(claim => {
        this.claimForm.patchValue(claim);
        this.loading = false;
      });
    }
  }

  onSubmit() {
    this.submitted = true;
    if (this.claimForm.invalid) return;
    this.loading = true;
    const claim: Claim = this.claimForm.value;
    if (this.isEdit && this.claimId) {
      this.claimsService.updateClaim(this.claimId, claim).subscribe(() => {
        this.loading = false;
        this.router.navigate(['/claims']);
      });
    } else {
      this.claimsService.createClaim(claim).subscribe(() => {
        this.loading = false;
        this.router.navigate(['/claims']);
      });
    }
  }

  cancel() {
    this.router.navigate(['/claims']);
  }
}
