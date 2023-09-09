import EuclideanGeometry.Foundation.Axiom.Position

noncomputable section
namespace EuclidGeom

class Line (P : Type _) [EuclideanPlane P] where 
  carrier : Set P
  linear : ∀ (A B C : P), (A ∈ carrier) → (B ∈ carrier) → (C ∈ carrier) → colinear A B C  
  maximal : ∀ (A B : P), (A ∈ carrier) → (B ∈ carrier) → (B ≠ A) → (∀ (C : P), colinear A B C → (C ∈ carrier))
  nontriv : ∃ (A B : P), (A ∈ carrier) ∧ (B ∈ carrier) ∧ (B ≠ A)

namespace Line

variable  {P : Type _} [EuclideanPlane P] 

-- define a line from two points 

def mk_pt_pt (A B : P) (h : B ≠ A) : Line P where
  carrier := {C : P | ∃ t : ℝ, VEC A C = t • VEC A B}
  linear := sorry
  maximal := sorry
  nontriv := by sorry

end Line

scoped notation "LIN" => Line.mk_pt_pt 

variable {P : Type _} [EuclideanPlane P]

/- def coe from ray to line-/

def Ray.toLine (r : Ray P) : Line P where
  carrier := {C : P | ∃ t : ℝ, VEC r.source C = t • r.toDir.toVec}
  linear := sorry
  maximal := sorry
  nontriv := sorry

instance : Coe (Ray P) (Line P) where
  coe := Ray.toLine

/- def coe from non trivial segment to line-/

def Seg.toLine_of_nontriv (s : Seg P) (hs : s.is_nontriv) : Line P where
  -- carrier := {C : P | ∃ t : ℝ, VEC s.source C = t • ?}
  carrier := sorry
  linear := sorry
  maximal := sorry
  nontriv := sorry

/- Def of point lies on a line -/
def IsOnLine (a : P) (l : Line P) : Prop :=
  a ∈ l.carrier

instance : HasLiesOn P (Line P) where
  lies_on := IsOnLine

section Compaitiblity_of_coersions
-- If a point lies on a ray, then it lies on the line associated to the ray.
theorem lies_on_line_of_ray_of_lies_on_ray {a : P} {l : Ray P} (h : a LiesOn l) : a LiesOn l := sorry

-- If A and B are two distinct points, they lie on the line AB
theorem source_or_ray_lies_on_line_of_ray (l : Ray P) : l.source LiesOn l := sorry

theorem pt_lies_on_line_of_pt_pt_of_ne {A B : P} (h: B ≠ A) : A LiesOn LIN A B h ∧ B LiesOn LIN A B h := sorry

-- The line defined from a nontrivial segment is equal to the line defined from the ray associated this nontriial segment

theorem line_of_nontriv_seg_eq_line_of_ray_of_nontriv_seg {seg : Seg P} (nontriv : seg.is_nontriv) : seg.toLine_of_nontriv nontriv = (seg.toRay_of_nontriv nontriv).toLine := sorry

theorem line_eq_line_of_seg_of_pt_pt_of_ne {A B : P} (h : B ≠ A) : LIN A B h = Seg.toLine_of_nontriv (SEG A B) h := sorry

theorem line_eq_line_of_pt_pt_of_ne {A B : P} {l : Line P} (h : B ≠ A) (hA : A LiesOn l) (hB : B LiesOn l) : l = Line.mk_pt_pt A B h := sorry

theorem lies_on_iff_colinear_of_ne {A B C : P}  (h : B ≠ A) : (C LiesOn LIN A B h) ↔ colinear A B C:= sorry

end Compaitiblity_of_coersions

section Archimedean_property
-- there are two distinct points on a line
theorem exists_ne_pt_pt_lies_on_of_line (l : Line P) : ∃ A B : P, B ≠ A ∧ A LiesOn l ∧ B LiesOn l  := sorry

-- Given distinct A B on a line, there exist C s.t. C LiesOn AB (a cor of Archimedean_property in Seg) and there exist D s.t. B LiesOn AD
end Archimedean_property

-- where should this theorem be placed?
theorem vec_eq_mul_vec_of_pt_pt_on_line (l : Line P) (A B C D : P) (hA : A LiesOn l) (hB : B LiesOn l) (hC : C LiesOn l) (hD : D LiesOn l) (h : B ≠ A) : ∃ (t : ℝ), VEC C D = t • VEC A B := sorry

-- def Line.toProj' (l : Line P) : Proj := by
--  choose A B h _ _ using (exists_ne_pt_pt_lies_on_of_line l)
--  exact (SEG A B).toProj_of_nontriv h

-- theorem eq_toProj_of_four_pt_on_line (l : Line P) (A B C D : P) (hA : A LiesOnLine l) (hB : B LiesOnLine l) (hC : C LiesOnLine l) (hD : D LiesOnLine l) (h₁ : B ≠ A) (h₂ : D ≠ C) : (SEG A B).toProj_of_nontriv h₁ = (SEG C D).toProj_of_nontriv h₂ := sorry

 theorem exist_unique_proj_of_line (l : Line P) : ∃! proj : Proj, ∀ (A B : P) (ha : A LiesOn l) (hb : B LiesOn l) (nontriv : B ≠ A), (SEG A B).toProj_of_nontriv nontriv = proj := by sorry

def Line.toProj (l : Line P) : Proj := by 
  choose proj _ using (exist_unique_proj_of_line l)
  use proj

end EuclidGeom