import EuclideanGeometry.Foundation.Axiom.Linear.Parallel

noncomputable section
namespace EuclidGeom

open Line

variable {P : Type _} [EuclideanPlane P] {α β γ : Type*} [ProjObj α] [ProjObj β] [ProjObj γ]
  {l₁ : α} {l₂ : β} {l₃ : γ}

def perpendicular (l₁ : α) (l₂ : β) : Prop :=
  ProjObj.toProj l₁ = (ProjObj.toProj l₂).perp

scoped infix : 50 " IsPerpendicularTo " => perpendicular

scoped infix : 50 " ⟂ " => perpendicular

section Notation
open Lean

syntax (name := perpendicularNotation) (priority := high) term:50 " ⟂ " term:51 : term

@[macro perpendicularNotation] def perpendicularNotationImpl : Macro
  | `($l:term ⟂ $r:term) => `(perpendicular $l $r)
  | _ => Macro.throwUnsupported

end Notation

namespace perpendicular

@[simp]
protected theorem irrefl (l : α) : ¬ (l ⟂ l) :=
  sorry

protected theorem symm (h : l₁ ⟂ l₂) : (l₂ ⟂ l₁) := by
  rw [perpendicular, Proj.perp, h, Proj.perp, vadd_vadd]
  norm_cast
  simp

end perpendicular

section Perpendicular_and_parallel

theorem parallel_of_perp_perp (h₁ : l₁ ⟂ l₂) (h₂ : l₂ ⟂ l₃) : l₁ ∥ l₃ := by
  unfold perpendicular at h₂
  simp only [perpendicular, h₂, Proj.perp_perp] at h₁
  exact h₁

theorem perp_of_parallel_perp (h₁ : l₁ ∥ l₂) (h₂ : l₂ ⟂ l₃) : l₁ ⟂ l₃ := h₁.trans h₂

theorem perp_of_perp_parallel (h₁ : l₁ ⟂ l₂) (h₂ : l₂ ∥ l₃) : l₁ ⟂ l₃ := h₁.trans (congrArg Proj.perp h₂)

theorem toProj_ne_toProj_of_perp (h : l₁ ⟂ l₂) : ProjObj.toProj l₁ ≠ ProjObj.toProj l₂ :=
  sorry

theorem not_parallel_of_perp (h : l₁ ⟂ l₂) : ¬ l₁ ∥ l₂ := toProj_ne_toProj_of_perp h

end Perpendicular_and_parallel

section Perpendicular_constructions

def perp_line (A : P) (l : Line P) := Line.mk_pt_proj A (l.toProj.perp)

@[simp]
theorem toProj_of_perp_line_eq_toProj_perp (A : P) (l : Line P) : (perp_line A l).toProj = l.toProj.perp :=
  proj_eq_of_mk_pt_proj A l.toProj.perp

theorem perp_line_perp (A : P) (l : Line P) : perp_line A l ⟂ l := toProj_of_perp_line_eq_toProj_perp A l

theorem toProj_ne_perp_toProj (A : P) (l : Line P) : l.toProj ≠ (perp_line A l).toProj :=
  Ne.trans_eq (perpendicular.irrefl l) (toProj_of_perp_line_eq_toProj_perp A l).symm

def perp_foot (A : P) (l : Line P) : P := Line.inx l (perp_line A l) (toProj_ne_perp_toProj A l)

def dist_pt_line (A : P) (l : Line P) := Seg.length (SEG A (perp_foot A l))

theorem perp_foot_lies_on_line (A : P) (l : Line P) : perp_foot A l LiesOn l := (Line.inx_is_inx _).1

theorem perp_foot_eq_self_iff_lies_on (A : P) (l : Line P) : perp_foot A l = A ↔ A LiesOn l := ⟨
  fun h ↦ Eq.mpr (h.symm ▸ Eq.refl (A LiesOn l)) (perp_foot_lies_on_line A l),
  fun h ↦ (inx_of_line_eq_inx _ ⟨h, (pt_lies_on_of_mk_pt_proj A (Proj.perp (Line.toProj l)))⟩).symm⟩

theorem perp_foot_ne_self_iff_not_lies_on (A : P) (l : Line P) : perp_foot A l ≠ A ↔ ¬ A LiesOn l :=
  (perp_foot_eq_self_iff_lies_on A l).not

theorem pt_ne_iff_not_lies_on_of_eq_perp_foot {A B : P} {l : Line P} (h : B = perp_foot A l) : B ≠ A ↔ ¬ A LiesOn l := by
  rw [h]
  exact (perp_foot_ne_self_iff_not_lies_on A l)

theorem line_of_self_perp_foot_eq_perp_line_of_not_lies_on {A : P} {l : Line P} (h : ¬ A LiesOn l) : LIN A (perp_foot A l) ((perp_foot_ne_self_iff_not_lies_on A l).2 h) = perp_line A l :=
  eq_line_of_pt_pt_of_ne (_h := ⟨(perp_foot_ne_self_iff_not_lies_on A l).2 h⟩) (pt_lies_on_of_mk_pt_proj A l.toProj.perp) (Line.inx_is_inx (toProj_ne_perp_toProj A l)).2

theorem line_of_self_perp_foot_perp_line_of_not_lies_on {A : P} {l : Line P} (h : ¬ A LiesOn l) : LIN A (perp_foot A l) ((perp_foot_ne_self_iff_not_lies_on A l).2 h) ⟂ l :=
  (congrArg toProj (line_of_self_perp_foot_eq_perp_line_of_not_lies_on h)).trans (perp_line_perp A l)

theorem dist_eq_zero_iff_lies_on (A : P) (l : Line P) : dist_pt_line A l = 0 ↔ A LiesOn l :=
  Seg.length_eq_zero_iff_deg.trans (perp_foot_eq_self_iff_lies_on A l)

theorem perp_foot_unique {A B : P} {l : DirLine P} (h : B LiesOn l) [_hne : PtNe A B] (hp : LIN A B ⟂ l) : perp_foot A l = B := sorry

-- `Maybe the proof of following theorems should require the Pythagorean Theorem.`
theorem dist_pt_line_shortest (A B : P) {l : Line P} (h : B LiesOn l) : dist A B ≥ dist_pt_line A l := sorry

theorem eq_dist_eq_perp_foot {A B : P} {l : DirLine P} (h : A LiesOn l) (heq : dist B A = dist_pt_line B l) : A = perp_foot B l := sorry

end Perpendicular_constructions

section Perpendicular_inner_product

theorem perp_of_inner_product_eq_zero (v w : VecND) (h : inner v.1 w.1 = (0 : ℝ)) : v ⟂ w := by
  unfold perpendicular Proj.perp
  rw [Proj.vadd_coe_left]
  erw [Proj.map_vecND_toProj]
  simp only [Dir.map_apply, ne_eq, LinearEquiv.restrictScalars_apply, VecND.toDir_toProj]
  erw [VecND.toProj_eq_toProj_iff]
  obtain ⟨ ⟨ xv, yv ⟩, hv ⟩ := v
  obtain ⟨ ⟨ xw, yw ⟩, hw ⟩ := w
  rw [Vec.real_inner_apply] at h
  simp only [Vec.rotate_mk, AngValue.cos_coe, Real.cos_pi_div_two, zero_mul, AngValue.sin_coe, Real.sin_pi_div_two, one_mul, zero_sub, zero_add, Vec.smul_mk, mul_neg, Vec.mk.injEq] at h ⊢
  have : xw ≠ 0 ∨ yw ≠ 0 := by
    contrapose! hw
    obtain ⟨rfl, rfl⟩ := hw
    rfl
  rcases this
  · use yv / xw
    field_simp
    linarith
  · use -xv / yw
    field_simp
    linarith

theorem inner_product_eq_zero_of_perp (v w : VecND) (h : v ⟂ w) : inner v.1 w.1 = (0 : ℝ) := by
  unfold perpendicular Proj.perp at h
  rw [Proj.vadd_coe_left] at h
  erw [Proj.map_vecND_toProj] at h
  simp only [Dir.map_apply, ne_eq, LinearEquiv.restrictScalars_apply, VecND.toDir_toProj] at h 
  erw [VecND.toProj_eq_toProj_iff] at h
  obtain ⟨ ⟨ xv, yv ⟩, hv ⟩ := v
  obtain ⟨ ⟨ xw, yw ⟩, hw ⟩ := w
  rw [Vec.real_inner_apply]
  simp only [Vec.rotate_mk, AngValue.cos_coe, Real.cos_pi_div_two, zero_mul, AngValue.sin_coe, Real.sin_pi_div_two, one_mul, zero_sub, zero_add, Vec.smul_mk, mul_neg, Vec.mk.injEq] at h ⊢
  obtain ⟨a, ⟨ h₁, h₂ ⟩⟩ := h
  rw [h₁, h₂]
  linarith


end Perpendicular_inner_product

end EuclidGeom
